import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos_store/design/app_colors.dart';
import 'package:pos_store/design/app_spacing.dart';
import 'package:pos_store/providers/programs_provider.dart';

class DailyReconciliationScreen extends ConsumerStatefulWidget {
  const DailyReconciliationScreen({super.key});

  @override
  ConsumerState<DailyReconciliationScreen> createState() =>
      _DailyReconciliationScreenState();
}

class _DailyReconciliationScreenState
    extends ConsumerState<DailyReconciliationScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final reconciliation = ref.watch(dailyReconciliationProvider(selectedDate));
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final currencyFormatter = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      appBar: AppBar(title: const Text('تسوية يومية'), elevation: 0),
      body: Column(
        children: [
          // Date Selection
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateFormatter.format(selectedDate)),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: reconciliation.when(
              data: (recon) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      // Opening Balance
                      _buildSectionCard(
                        context,
                        title: 'الرصيد الافتتاحي',
                        value: recon.openingBalance,
                        color: Colors.grey,
                        currencyFormatter: currencyFormatter,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Cash Received Section
                      _buildSectionHeader(context, 'النقد المستقبل'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDetailRow(
                        context,
                        label: 'كهرباء وفواتير',
                        amount: recon.electricityRecharges,
                        currencyFormatter: currencyFormatter,
                      ),
                      _buildDetailRow(
                        context,
                        label: 'محفظة العميل',
                        amount: recon.walletOperations,
                        currencyFormatter: currencyFormatter,
                      ),
                      _buildDetailRow(
                        context,
                        label: 'تيليلينك',
                        amount: recon.telelinkOperations,
                        currencyFormatter: currencyFormatter,
                      ),
                      _buildDetailRow(
                        context,
                        label: 'فاراه نت (المبلغ)',
                        amount: recon.farahnetAmount,
                        currencyFormatter: currencyFormatter,
                      ),
                      const Divider(height: AppSpacing.lg),
                      _buildDetailRow(
                        context,
                        label: 'إجمالي النقد',
                        amount:
                            recon.electricityRecharges +
                            recon.walletOperations +
                            recon.telelinkOperations +
                            recon.farahnetAmount,
                        currencyFormatter: currencyFormatter,
                        isBold: true,
                        color: Colors.green,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Profit Section
                      _buildSectionHeader(context, 'الأرباح'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDetailRow(
                        context,
                        label: 'ربح فاراه نت (2%)',
                        amount: recon.farahnetProfit,
                        currencyFormatter: currencyFormatter,
                        color: Colors.green,
                      ),
                      const Divider(height: AppSpacing.lg),
                      _buildDetailRow(
                        context,
                        label: 'إجمالي الأرباح',
                        amount: recon.farahnetProfit,
                        currencyFormatter: currencyFormatter,
                        isBold: true,
                        color: Colors.green,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Topups Section
                      _buildSectionHeader(context, 'إضافة رصيد'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDetailRow(
                        context,
                        label: 'محفظة العميل',
                        amount: recon.walletTopups,
                        currencyFormatter: currencyFormatter,
                        color: Colors.blue,
                      ),
                      _buildDetailRow(
                        context,
                        label: 'تيليلينك',
                        amount: recon.telelinkTopups,
                        currencyFormatter: currencyFormatter,
                        color: Colors.blue,
                      ),
                      const Divider(height: AppSpacing.lg),
                      _buildDetailRow(
                        context,
                        label: 'إجمالي الإضافات',
                        amount: recon.walletTopups + recon.telelinkTopups,
                        currencyFormatter: currencyFormatter,
                        isBold: true,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Settlements Section
                      _buildSectionHeader(context, 'التسويات'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDetailRow(
                        context,
                        label: 'محفظة العميل',
                        amount: -recon.walletSettlements,
                        currencyFormatter: currencyFormatter,
                        color: Colors.red,
                        prefix: '- ',
                      ),
                      _buildDetailRow(
                        context,
                        label: 'تيليلينك',
                        amount: -recon.telelinkSettlements,
                        currencyFormatter: currencyFormatter,
                        color: Colors.red,
                        prefix: '- ',
                      ),
                      const Divider(height: AppSpacing.lg),
                      _buildDetailRow(
                        context,
                        label: 'إجمالي التسويات',
                        amount:
                            -(recon.walletSettlements +
                                recon.telelinkSettlements),
                        currencyFormatter: currencyFormatter,
                        isBold: true,
                        color: Colors.red,
                        prefix: '- ',
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Closing Balance
                      _buildSectionCard(
                        context,
                        title: 'الرصيد الختامي',
                        value: recon.closingBalance,
                        color: AppColors.blue600,
                        currencyFormatter: currencyFormatter,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Action Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement save/print reconciliation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تمت التسوية برنجاح')),
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('تأكيد التسوية'),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('خطأ: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.blue600,
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required int amount,
    required NumberFormat currencyFormatter,
    Color? color,
    bool isBold = false,
    String prefix = '',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '$prefix${currencyFormatter.format(amount / 100)} ﷼',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required int value,
    required Color color,
    required NumberFormat currencyFormatter,
  }) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${currencyFormatter.format(value / 100)} ﷼',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
