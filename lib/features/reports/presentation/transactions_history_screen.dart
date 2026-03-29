import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/formatting/money.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/enums/transaction_status.dart';
import '../../../providers/db_provider.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_radius.dart';
import '../../../design/app_text_styles.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../../inventory/presentation/daily_services_inventory_screen.dart';
import '../../inventory/providers/products_providers.dart';
import '../domain/transaction_history_model.dart';
import '../providers/transaction_history_provider.dart';

class TransactionsHistoryScreen extends ConsumerStatefulWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  ConsumerState<TransactionsHistoryScreen> createState() =>
      _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState
    extends ConsumerState<TransactionsHistoryScreen> {
  DateTime _selectedDate = DateTime.now();

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  String _formatCents(int cents) => formatMoneyCents(cents);

  String _lang(String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  Future<void> _showReverseConfirmation(
    BuildContext context,
    UnifiedTransaction transaction,
  ) async {
    final shouldReverse = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: Directionality.of(context),
        child: AlertDialog(
          title: Text(_lang('تأكيد الاسترجاع', 'Confirm Reversal')),
          content: Text(
            _lang(
              'هل أنت متأكد من استرجاع هذه العملية؟ سيتم خصم أرباحها من التقارير.',
              'Are you sure you want to reverse this transaction? Its profits will be deducted from reports.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(_lang('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(_lang('تأكيد', 'Confirm')),
            ),
          ],
        ),
      ),
    );

    if (shouldReverse == true) {
      final db = ref.read(dbProvider);
      final success = await db.reverseTransaction(
        transaction.id,
        transaction.type.name,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _lang(
                  'تم استرجاع العملية بنجاح',
                  'Transaction reversed successfully',
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh the list
          ref.invalidate(transactionsHistoryProvider);
          ref.invalidate(detailedProfitProvider);
          ref.invalidate(dashboardDataProvider);
          ref.invalidate(productsStreamProvider);
          ref.invalidate(allProductsProvider);
          ref.invalidate(dailyInventoryDataProvider);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _lang('فشل استرجاع العملية', 'Failed to reverse transaction'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    final range = TransactionDateRange(
      start: _startOfDay(_selectedDate),
      end: _endOfDay(_selectedDate),
    );

    final transactionsAsync = ref.watch(transactionsHistoryProvider(range));

    return GradientScaffold(
      appBar: AppTopBar(title: _lang('سجل المعاملات', 'Transactions History')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with date selector
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _lang('جميع المعاملات', 'All Transactions'),
                              style: AppTextStyles.h2.copyWith(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _lang(
                                'عرض جميع العمليات والمبيعات',
                                'View all operations and sales',
                              ),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Date selector button
                      AppCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: InkWell(
                          onTap: _selectDate,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                DateFormat('yyyy-MM-dd').format(_selectedDate),
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_drop_down,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Summary cards
                transactionsAsync.when(
                  data: (summary) =>
                      _buildSummaryCards(context, summary, isDark, isRTL),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppErrorState(
                      message: _lang(
                        'فشل تحميل المعاملات',
                        'Failed to load transactions',
                      ),
                      details: error.toString(),
                      stackTrace: stack,
                      onRetry: () =>
                          ref.invalidate(transactionsHistoryProvider),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Detailed profit breakdown
                _buildDetailedProfitBreakdown(context, isDark, isRTL, range),

                const SizedBox(height: AppSpacing.md),

                // Transactions list
                transactionsAsync.when(
                  data: (summary) =>
                      _buildTransactionsList(context, summary, isDark, isRTL),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppErrorState(
                      message: _lang(
                        'فشل تحميل المعاملات',
                        'Failed to load transactions',
                      ),
                      details: error.toString(),
                      stackTrace: stack,
                      onRetry: () =>
                          ref.invalidate(transactionsHistoryProvider),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    TransactionsSummary summary,
    bool isDark,
    bool isRTL,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          int columns = 3;
          if (width < 600) {
            columns = 1;
          } else if (width < 900) {
            columns = 2;
          }

          return GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.5,
            children: [
              _SummaryCard(
                label: _lang('إجمالي المعاملات', 'Total Transactions'),
                value: summary.transactions.length.toString(),
                icon: Icons.receipt_long,
                color: Colors.blue,
                isDark: isDark,
              ),
              _SummaryCard(
                label: _lang('إجمالي الإيرادات', 'Total Revenue'),
                value: _formatCents(summary.totalRevenueCents),
                icon: Icons.attach_money,
                color: Colors.green,
                isDark: isDark,
              ),
              _SummaryCard(
                label: _lang('إجمالي الأرباح', 'Total Profit'),
                value: _formatCents(summary.totalProfitCents),
                icon: Icons.trending_up,
                color: Colors.amber,
                isDark: isDark,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailedProfitBreakdown(
    BuildContext context,
    bool isDark,
    bool isRTL,
    TransactionDateRange range,
  ) {
    final detailedProfitAsync = ref.watch(detailedProfitProvider(range));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: detailedProfitAsync.when(
          data: (breakdown) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _lang('تفصيل الأرباح', 'Profit Breakdown'),
                    style: AppTextStyles.h3.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.xs),

              // Sales breakdown
              _ProfitDetailRow(
                label: _lang(
                  'إجمالي المبيعات (قبل الخصم)',
                  'Total Sales (Before Discount)',
                ),
                value: _formatCents(breakdown.totalSalesBeforeDiscount),
                isDark: isDark,
                isSubitem: false,
              ),
              _ProfitDetailRow(
                label: _lang('- الخصومات', '- Discounts'),
                value: '-${_formatCents(breakdown.totalDiscounts)}',
                isDark: isDark,
                isSubitem: true,
                valueColor: Colors.red,
              ),
              _ProfitDetailRow(
                label: _lang('= صافي المبيعات', '= Net Sales'),
                value: _formatCents(breakdown.netSalesRevenue),
                isDark: isDark,
                isSubitem: true,
                isBold: true,
              ),
              _ProfitDetailRow(
                label: _lang('- تكلفة البضاعة', '- Cost of Goods'),
                value: '-${_formatCents(breakdown.costOfGoodsSold)}',
                isDark: isDark,
                isSubitem: true,
                valueColor: Colors.red,
              ),
              _ProfitDetailRow(
                label: _lang('= ربح المبيعات', '= Sales Profit'),
                value: _formatCents(breakdown.salesProfit),
                isDark: isDark,
                isSubitem: true,
                isBold: true,
                valueColor: AppColors.green600,
              ),

              const SizedBox(height: AppSpacing.xs),
              const Divider(),
              const SizedBox(height: AppSpacing.xs),

              // Other profits
              if (breakdown.repairsProfit > 0)
                _ProfitDetailRow(
                  label: _lang('ربح الصيانة', 'Repairs Profit'),
                  value: _formatCents(breakdown.repairsProfit),
                  isDark: isDark,
                  valueColor: Colors.orange,
                ),
              if (breakdown.servicesProfit > 0)
                _ProfitDetailRow(
                  label: _lang('ربح الخدمات', 'Services Profit'),
                  value: _formatCents(breakdown.servicesProfit),
                  isDark: isDark,
                  valueColor: Colors.teal,
                ),
              if (breakdown.telelinkProfit > 0)
                _ProfitDetailRow(
                  label: _lang('ربح تيلي لينك', 'TeleLink Profit'),
                  value: _formatCents(breakdown.telelinkProfit),
                  isDark: isDark,
                  valueColor: Colors.blue,
                ),
              if (breakdown.electricityProfit > 0)
                _ProfitDetailRow(
                  label: _lang('ربح الكهرباء', 'Electricity Profit'),
                  value: _formatCents(breakdown.electricityProfit),
                  isDark: isDark,
                  valueColor: Colors.amber,
                ),

              const SizedBox(height: AppSpacing.xs),
              const Divider(thickness: 2),
              const SizedBox(height: AppSpacing.xs),

              // Total profit
              _ProfitDetailRow(
                label: _lang('إجمالي الربح الصافي', 'Total Net Profit'),
                value: _formatCents(breakdown.totalProfit),
                isDark: isDark,
                isBold: true,
                isLarge: true,
                valueColor: AppColors.green600,
              ),
            ],
          ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                _lang(
                  'فشل تحميل تفصيل الأرباح',
                  'Failed to load profit breakdown',
                ),
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
    BuildContext context,
    TransactionsSummary summary,
    bool isDark,
    bool isRTL,
  ) {
    if (summary.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _lang('لا توجد معاملات', 'No transactions'),
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _lang(
                'لا توجد معاملات في هذا التاريخ',
                'No transactions on this date',
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: summary.transactions.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final transaction = summary.transactions[index];
        return _TransactionCard(
          transaction: transaction,
          isDark: isDark,
          isRTL: isRTL,
          onReverse: () => _showReverseConfirmation(context, transaction),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.h3.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final UnifiedTransaction transaction;
  final bool isDark;
  final bool isRTL;
  final VoidCallback onReverse;

  const _TransactionCard({
    required this.transaction,
    required this.isDark,
    required this.isRTL,
    required this.onReverse,
  });

  String _formatCents(int cents) => formatMoneyCents(cents);

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  String _lang(String ar, String en) {
    return isRTL ? ar : en;
  }

  @override
  Widget build(BuildContext context) {
    final isReversed = transaction.status == TransactionStatus.reversed;

    return Opacity(
      opacity: isReversed ? 0.5 : 1.0,
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: transaction.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                transaction.icon,
                color: isReversed ? Colors.grey : transaction.color,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isRTL ? transaction.labelAr : transaction.labelEn,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isReversed
                              ? Colors.grey
                              : (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${_formatTime(transaction.createdAt)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (isReversed) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.refresh,
                                size: 12,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _lang('مسترجعة', 'Reversed'),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (transaction.customerName != null) ...[
                    Text(
                      transaction.customerName!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  if (transaction.description != null)
                    Text(
                      transaction.description!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Amount, Profit and Reverse Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCents(transaction.amountCents),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isReversed
                        ? Colors.grey
                        : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isReversed
                        ? Colors.grey.withOpacity(0.1)
                        : AppColors.green600.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 12,
                        color: isReversed ? Colors.grey : AppColors.green600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatCents(transaction.profitCents),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isReversed ? Colors.grey : AppColors.green600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isReversed) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: onReverse,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(
                        _lang('استرجاع', 'Reverse'),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfitDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isSubitem;
  final bool isBold;
  final bool isLarge;
  final Color? valueColor;

  const _ProfitDetailRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.isSubitem = false,
    this.isBold = false,
    this.isLarge = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isLarge ? 8.0 : 4.0,
        horizontal: isSubitem ? AppSpacing.md : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: (isLarge ? AppTextStyles.h4 : AppTextStyles.bodyMedium)
                  .copyWith(
                    fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
                    color: isDark
                        ? (isSubitem
                              ? AppColors.darkTextSecondary
                              : AppColors.darkTextPrimary)
                        : (isSubitem
                              ? AppColors.textSecondary
                              : AppColors.textPrimary),
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: (isLarge ? AppTextStyles.h3 : AppTextStyles.bodyLarge)
                .copyWith(
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                  color:
                      valueColor ??
                      (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
                ),
          ),
        ],
      ),
    );
  }
}
