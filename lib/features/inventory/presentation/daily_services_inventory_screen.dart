import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_store/core/formatting/money.dart';
import 'package:pos_store/core/ui/widgets/app_card.dart';
import 'package:pos_store/core/ui/widgets/app_top_bar.dart';
import 'package:pos_store/core/ui/widgets/gradient_scaffold.dart';
import 'package:pos_store/design/app_colors.dart';
import 'package:pos_store/design/app_spacing.dart';
import 'package:pos_store/providers/db_provider.dart';
import 'package:pos_store/data/db/app_database.dart';
import '../../dashboard/providers/dashboard_provider.dart';

// Providers
final dailyInventoryDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final dailyInventoryDataProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, DateTime>((ref, date) async {
      final db = ref.watch(dbProvider);

      // Get daily inventory records
      final inventoryRecords = await db.getDailyInventory(date);
      final inventoryMap = {for (var r in inventoryRecords) r.provider: r};

      // Get service transactions for the day
      final transactions = await db.getServiceTransactionsForDate(date);

      // Aggregate transactions by provider
      final salesMap = <String, int>{};
      final profitMap = <String, int>{};

      for (final tx in transactions) {
        // Determine provider key
        // Map 'bills', 'games', 'balance' back to 'telelink' for inventory grouping?
        // Or keep them separate if we want inventory per type?
        // The prompt says: "add how much balance in each website... and PalPay"
        // Usually balance is per provider (Telelink wallet, PalPay wallet).
        // So distinct types like Bills/Games might spend from the SAME Telelink wallet.
        // I will assume PER PROVIDER (Telelink, PalPay, Platform).

        // Logic: Sales reduce balance.
        // If provider is 'telelink', all telelink types count towards 'telelink' sales.

        final providerKey = tx.category == 'palpay' ? 'palpay' : tx.provider;
        // Map fawry/farahnet to 'websites' or keep as provider name?
        // Using provider code from db.

        salesMap[providerKey] = (salesMap[providerKey] ?? 0) + tx.amountCents;
        profitMap[providerKey] =
            (profitMap[providerKey] ?? 0) + (tx.profitCents ?? 0);
      }

      return {
        'inventory': inventoryMap,
        'sales': salesMap,
        'profit': profitMap,
      };
    });

class DailyServicesInventoryScreen extends ConsumerStatefulWidget {
  const DailyServicesInventoryScreen({super.key});

  @override
  ConsumerState<DailyServicesInventoryScreen> createState() =>
      _DailyServicesInventoryScreenState();
}

class _DailyServicesInventoryScreenState
    extends ConsumerState<DailyServicesInventoryScreen> {
  // Temporary state for editing before saving
  final Map<String, TextEditingController> _openingControllers = {};
  final Map<String, TextEditingController> _closingControllers = {};
  final Map<String, TextEditingController> _notesControllers = {};

  final List<String> _providers = [
    'telelink',
    'palpay',
    'platform',
    'fawry',
    'farahnet',
  ];

  @override
  void dispose() {
    for (var c in _openingControllers.values) {
      c.dispose();
    }
    for (var c in _closingControllers.values) {
      c.dispose();
    }
    for (var c in _notesControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _t(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  String _getProviderLabel(BuildContext context, String provider) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final labels = {
      'telelink': isAr ? 'تيليلينك' : 'Telelink',
      'palpay': isAr ? 'بال باي' : 'PalPay',
      'platform': isAr ? 'المنصة' : 'Platform',
      'fawry': isAr ? 'فوري' : 'Fawry',
      'farahnet': isAr ? 'فرح نت' : 'FarahNet',
    };
    return labels[provider] ?? provider;
  }

  void _initControllers(String provider, ServiceDailyInventoryData? data) {
    if (!_openingControllers.containsKey(provider)) {
      _openingControllers[provider] = TextEditingController(
        text: data != null ? (data.openingBalanceCents / 100).toString() : '0',
      );
    }
    if (!_closingControllers.containsKey(provider)) {
      _closingControllers[provider] = TextEditingController(
        text: data != null ? (data.closingBalanceCents / 100).toString() : '0',
      );
    }
    if (!_notesControllers.containsKey(provider)) {
      _notesControllers[provider] = TextEditingController(
        text: data?.notes ?? '',
      );
    }
  }

  Future<void> _saveinventory(String provider, DateTime date) async {
    final openingText = _openingControllers[provider]?.text ?? '0';
    final closingText = _closingControllers[provider]?.text ?? '0';
    final notes = _notesControllers[provider]?.text;

    final opening =
        (double.tryParse(openingText.replaceAll(',', '')) ?? 0) * 100;
    final closing =
        (double.tryParse(closingText.replaceAll(',', '')) ?? 0) * 100;

    try {
      await ref
          .read(dbProvider)
          .upsertDailyInventory(
            date: date,
            provider: provider,
            openingBalanceCents: opening.round(),
            closingBalanceCents: closing.round(),
            notes: notes,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _t(
                context,
                'تم حفظ جرد ${_getProviderLabel(context, provider)}',
                'Inventory saved for ${_getProviderLabel(context, provider)}',
              ),
            ),
          ),
        );
        ref.invalidate(dailyInventoryDataProvider);
        ref.invalidate(dashboardDataProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t(context, 'خطأ في الحفظ: $e', 'Save error: $e')),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(dailyInventoryDateProvider);
    final dataAsync = ref.watch(dailyInventoryDataProvider(date));

    return GradientScaffold(
      appBar: AppTopBar(
        title: _t(context, 'جرد الخدمات اليومي', 'Daily Services Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                ref.read(dailyInventoryDateProvider.notifier).state = picked;
              }
            },
          ),
        ],
      ),
      body: dataAsync.when(
        data: (data) {
          final inventoryMap =
              data['inventory'] as Map<String, ServiceDailyInventoryData>;
          final salesMap = data['sales'] as Map<String, int>;
          final profitMap = data['profit'] as Map<String, int>;

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 450,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.82, // Adjusted for card height
            ),
            itemCount: _providers.length,
            itemBuilder: (context, index) {
              final provider = _providers[index];
              final inventory = inventoryMap[provider];
              final sales = salesMap[provider] ?? 0;
              final profit = profitMap[provider] ?? 0;

              _initControllers(provider, inventory);

              return _buildProviderCard(
                context,
                provider,
                inventory,
                sales,
                profit,
                date,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildProviderCard(
    BuildContext context,
    String provider,
    ServiceDailyInventoryData? inventory,
    int sales,
    int profit,
    DateTime date,
  ) {
    final openingController = _openingControllers[provider]!;
    final closingController = _closingControllers[provider]!;

    // Calculate expected closing dynamically based on current input
    // Expected = Opening - Sales
    // To update UI instantly when opening changes, we might need to listen to controller
    // or use a ValueListenableBuilder. For simplicity, we'll calculate based on controller text
    // inside a ValueListenableBuilder if we want real-time updates, or just rely on manual refresh/save.
    // Let's use AnimatedBuilder to listen to opening controller.

    return AnimatedBuilder(
      animation: openingController,
      builder: (context, _) {
        return AnimatedBuilder(
          animation: closingController,
          builder: (context, _) {
            final opening = (double.tryParse(openingController.text) ?? 0);
            final closing = (double.tryParse(closingController.text) ?? 0);
            final salesAmt = sales / 100.0;
            final expectedClosing = opening - salesAmt;
            final difference = closing - expectedClosing;

            final isSaved =
                inventory != null &&
                (inventory.openingBalanceCents / 100) == opening &&
                (inventory.closingBalanceCents / 100) == closing;

            return AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _getProviderLabel(context, provider),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green500.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.green500),
                        ),
                        child: Text(
                          '${_t(context, 'الربح', 'Profit')}: ${formatMoneyCents(profit)}',
                          style: const TextStyle(
                            color: AppColors.green500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMoneyInput(
                          controller: openingController,
                          label: _t(
                            context,
                            'الرصيد الافتتاحي',
                            'Opening Balance',
                          ),
                          color: Colors.blue.shade100,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildInfoBox(
                          label: _t(context, 'المبيعات', 'Sales'),
                          value: formatMoneyCents(sales),
                          color: Colors.orange.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoBox(
                          label: _t(
                            context,
                            'المتوقع إغلاقه',
                            'Expected Closing',
                          ),
                          value: expectedClosing.toStringAsFixed(2),
                          color: Colors.purple.shade100,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildMoneyInput(
                          controller: closingController,
                          label: _t(
                            context,
                            'الرصيد الحالي',
                            'Current Balance',
                          ),
                          color: Colors.green.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoBox(
                    label: _t(
                      context,
                      'الفرق (عجز / زيادة)',
                      'Difference (Deficit / Surplus)',
                    ),
                    value: difference.toStringAsFixed(2),
                    // If difference is near 0, green. If negative (deficit), red. Positive (surplus), blue?
                    textColor: difference.abs() < 0.01
                        ? Colors.grey.shade800
                        : (difference < 0
                              ? AppColors.red500
                              : Colors.blue.shade800),
                    color: difference.abs() < 0.01
                        ? Colors.grey.shade100
                        : (difference < 0
                              ? AppColors.red500.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _notesControllers[provider],
                    decoration: InputDecoration(
                      labelText: _t(context, 'ملاحظات', 'Notes'),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () => _saveinventory(provider, date),
                    icon: const Icon(Icons.save),
                    label: Text(_t(context, 'حفظ الجرد', 'Save Inventory')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSaved
                          ? Colors.grey
                          : AppColors.blue600,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMoneyInput({
    required TextEditingController controller,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required String label,
    required String value,
    required Color color,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
