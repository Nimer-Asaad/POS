import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatting/money.dart';
import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/stat_card.dart';
import 'package:pos_store/l10n/app_localizations.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../design/app_colors.dart';

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

final salesSummaryProvider = FutureProvider.autoDispose
    .family<SalesSummary, ReportsRange>((ref, range) async {
      final db = ref.watch(dbProvider);
      return db.getSalesSummary(range.from, range.to);
    });

final profitSummaryProvider = FutureProvider.autoDispose
    .family<ProfitSummary, ReportsRange>((ref, range) async {
      final db = ref.watch(dbProvider);
      return db.getProfitSummary(range.from, range.to);
    });

final repairStatsProvider = FutureProvider.autoDispose
    .family<RepairStats, ReportsRange>((ref, range) async {
      final db = ref.watch(dbProvider);
      return db.getRepairStats(range.from, range.to);
    });

final topPartsProvider = FutureProvider.autoDispose
    .family<List<TopPartUsage>, ReportsRange>((ref, range) async {
      final db = ref.watch(dbProvider);
      return db.getTopRepairParts(range.from, range.to);
    });

// Provider for repair profit in a time range
final repairProfitProvider = FutureProvider.autoDispose
    .family<int, ReportsRange>((ref, range) async {
      final db = ref.watch(dbProvider);
      return db.getRepairsProfit(range.from, range.to);
    });

// Provider for count of all devices in maintenance (not filtered by date)
final allMaintenanceDevicesProvider = FutureProvider.autoDispose((ref) async {
  final db = ref.watch(dbProvider);
  return db.getCurrentMaintenanceDevicesCount();
});

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  static const List<String> _filters = [
    'today',
    'last7',
    'thisMonth',
    'custom',
  ];

  String _selectedFilter = 'today';
  DateTimeRange? _customRange;

  String _filterLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'last7':
        return l10n.last7Days;
      case 'thisMonth':
        return l10n.thisMonth;
      case 'custom':
        return l10n.customRange;
      case 'today':
      default:
        return l10n.today;
    }
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  ReportsRange _currentRange(AppLocalizations l10n) {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'last7':
        final from = _startOfDay(now.subtract(const Duration(days: 6)));
        return ReportsRange(
          from: from,
          to: _endOfDay(now),
          label: l10n.last7Days,
        );
      case 'thisMonth':
        final from = DateTime(now.year, now.month, 1);
        return ReportsRange(
          from: from,
          to: _endOfDay(now),
          label: l10n.thisMonth,
        );
      case 'custom':
        if (_customRange != null) {
          return ReportsRange(
            from: _startOfDay(_customRange!.start),
            to: _endOfDay(_customRange!.end),
            label: l10n.customRange,
          );
        }
        return ReportsRange(
          from: _startOfDay(now),
          to: _endOfDay(now),
          label: l10n.today,
        );
      case 'today':
      default:
        return ReportsRange(
          from: _startOfDay(now),
          to: _endOfDay(now),
          label: l10n.today,
        );
    }
  }

  Future<void> _handleFilterChange(String? value) async {
    if (value == null) return;

    if (value == 'custom') {
      final range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        initialDateRange: _customRange,
      );

      if (range == null) return;

      setState(() {
        _customRange = range;
        _selectedFilter = value;
      });
      return;
    }

    setState(() {
      _selectedFilter = value;
    });
  }

  String _formatCents(int cents) => formatMoneyCents(cents);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final range = _currentRange(l10n);
    final salesSummaryAsync = ref.watch(salesSummaryProvider(range));
    final profitSummaryAsync = ref.watch(profitSummaryProvider(range));
    final topPartsAsync = ref.watch(topPartsProvider(range));
    final repairProfitAsync = ref.watch(repairProfitProvider(range));
    final maintenanceDevicesAsync = ref.watch(allMaintenanceDevicesProvider);

    return GradientScaffold(
      appBar: AppTopBar(title: l10n.reports),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.reportsAndStats,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          l10n.overview,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: _filters
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(_filterLabel(value, l10n)),
                                ),
                              )
                              .toList(),
                          onChanged: _handleFilterChange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Summary Stats Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 4;
                    if (constraints.maxWidth < 800) {
                      crossAxisCount = 1;
                    } else if (constraints.maxWidth < 1200) {
                      crossAxisCount = 2;
                    }

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.6,
                      children: [
                        salesSummaryAsync.when(
                          data: (s) => StatCard(
                            title: l10n.totalSales,
                            value: _formatCents(s.totalAmount),
                            icon: Icons.attach_money,
                            iconColor: AppColors.blue600,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => StatCard(
                            title: l10n.totalSales,
                            value: 'Error',
                            icon: Icons.error_outline,
                            iconColor: Colors.red,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                        ),
                        profitSummaryAsync.when(
                          data: (s) => StatCard(
                            title: l10n.estimatedProfit,
                            value: _formatCents(s.approximateProfit),
                            icon: Icons.trending_up,
                            iconColor: Colors.green,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                          loading: () => const SizedBox(),
                          error: (error, stack) => StatCard(
                            title: l10n.estimatedProfit,
                            value: 'Error',
                            icon: Icons.error_outline,
                            iconColor: Colors.red,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                        ),
                        repairProfitAsync.when(
                          data: (profit) => StatCard(
                            title: _lang(context, 'أرباح الصيانة', 'Repair Profit'),
                            value: _formatCents(profit),
                            icon: Icons.build_circle,
                            iconColor: Colors.orange,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                          loading: () => const SizedBox(),
                          error: (error, stack) => StatCard(
                            title: _lang(context, 'أرباح الصيانة', 'Repair Profit'),
                            value: 'Error',
                            icon: Icons.error_outline,
                            iconColor: Colors.red,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                        ),
                        maintenanceDevicesAsync.when(
                          data: (count) => StatCard(
                            title: _lang(context, 'عدد أجهزة الصيانة', 'Maintenance Devices'),
                            value: '$count',
                            icon: Icons.build,
                            iconColor: Colors.purple,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                          loading: () => const SizedBox(),
                          error: (error, stack) => StatCard(
                            title: _lang(context, 'عدد أجهزة الصيانة', 'Maintenance Devices'),
                            value: 'Error',
                            icon: Icons.error_outline,
                            iconColor: Colors.red,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                        ),
                        salesSummaryAsync.when(
                          data: (s) => StatCard(
                            title: l10n.invoiceCount,
                            value: '${s.salesCount}',
                            icon: Icons.receipt,
                            iconColor: Colors.orange,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                          loading: () => const SizedBox(),
                          error: (error, stack) => StatCard(
                            title: l10n.invoiceCount,
                            value: 'Error',
                            icon: Icons.error_outline,
                            iconColor: Colors.red,
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Detailed breakdown tables
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 900;

                    if (isCompact) {
                      // Stack vertically on small screens
                      return Column(
                        children: [
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.salesDetails,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16),
                                salesSummaryAsync.when(
                                  data: (summary) => Column(
                                    children: [
                                      _buildPaymentRow(
                                        '${l10n.cash} (Cash)',
                                        summary.cashTotal,
                                        Colors.green,
                                      ),
                                      _buildPaymentRow(
                                        '${l10n.card} (Card)',
                                        summary.cardTotal,
                                        Colors.blue,
                                      ),
                                      _buildPaymentRow(
                                        '${l10n.transfer} (Transfer)',
                                        summary.transferTotal,
                                        Colors.purple,
                                      ),
                                      _buildPaymentRow(
                                        '${l10n.credit} (Credit)',
                                        summary.creditTotal,
                                        Colors.orange,
                                      ),
                                    ],
                                  ),
                                  error: (error, stack) => AppErrorState(
                                    message: 'Failed to load sales summary',
                                    details: error.toString(),
                                    stackTrace: stack,
                                    onRetry: () => ref.invalidate(
                                      salesSummaryProvider(range),
                                    ),
                                  ),
                                  loading: () =>
                                      const LinearProgressIndicator(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.topRepairParts,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16),
                                topPartsAsync.when(
                                  data: (parts) {
                                    if (parts.isEmpty) {
                                      return Center(
                                        child: Text(
                                          _lang(
                                            context,
                                            'لا توجد بيانات',
                                            'No data',
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: parts.length > 5
                                          ? 5
                                          : parts.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(),
                                      itemBuilder: (context, index) {
                                        final part = parts[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            part.productName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: Chip(
                                            label: Text('${part.totalQty}'),
                                            backgroundColor: AppColors.blue600
                                                .withOpacity(0.1),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  error: (error, stack) => AppErrorState(
                                    message: 'Failed to load top parts',
                                    details: error.toString(),
                                    stackTrace: stack,
                                    onRetry: () =>
                                        ref.invalidate(topPartsProvider(range)),
                                  ),
                                  loading: () => const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    // Side-by-side on wide screens
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.salesDetails,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16),
                                salesSummaryAsync.when(
                                  data: (summary) => Column(
                                    children: [
                                      _buildPaymentRow(
                                        '${l10n.cash} (Cash)',
                                        summary.cashTotal,
                                        Colors.green,
                                      ),
                                      _buildPaymentRow(
                                        '${l10n.card} (Card)',
                                        summary.cardTotal,
                                        Colors.blue,
                                      ),
                                      _buildPaymentRow(
                                        '${l10n.transfer} (Transfer)',
                                        summary.transferTotal,
                                        Colors.purple,
                                      ),
                                      _buildPaymentRow(
                                        '${l10n.credit} (Credit)',
                                        summary.creditTotal,
                                        Colors.orange,
                                      ),
                                    ],
                                  ),
                                  error: (error, stack) => AppErrorState(
                                    message: 'Failed to load sales summary',
                                    details: error.toString(),
                                    stackTrace: stack,
                                    onRetry: () => ref.invalidate(
                                      salesSummaryProvider(range),
                                    ),
                                  ),
                                  loading: () =>
                                      const LinearProgressIndicator(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.topRepairParts,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16),
                                topPartsAsync.when(
                                  data: (parts) {
                                    if (parts.isEmpty) {
                                      return Center(
                                        child: Text(
                                          _lang(
                                            context,
                                            'لا توجد بيانات',
                                            'No data',
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: parts.length > 5
                                          ? 5
                                          : parts.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(),
                                      itemBuilder: (context, index) {
                                        final part = parts[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            part.productName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: Chip(
                                            label: Text('${part.totalQty}'),
                                            backgroundColor: AppColors.blue600
                                                .withOpacity(0.1),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  error: (error, stack) => AppErrorState(
                                    message: 'Failed to load top parts',
                                    details: error.toString(),
                                    stackTrace: stack,
                                    onRetry: () =>
                                        ref.invalidate(topPartsProvider(range)),
                                  ),
                                  loading: () => const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, int amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(
            _formatCents(amount),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ReportsRange {
  final DateTime from;
  final DateTime to;
  final String label;

  const ReportsRange({
    required this.from,
    required this.to,
    required this.label,
  });

  @override
  bool operator ==(Object other) {
    return other is ReportsRange &&
        other.from == from &&
        other.to == to &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(from, to, label);
}
