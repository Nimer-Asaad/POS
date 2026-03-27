import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatting/money.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_button.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../data/db/app_database.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_radius.dart';
import '../../../design/app_shadows.dart';
import '../../../providers/db_provider.dart';
import '../providers/supplier_providers.dart';

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

class PurchaseInvoicesScreen extends ConsumerStatefulWidget {
  const PurchaseInvoicesScreen({super.key});

  @override
  ConsumerState<PurchaseInvoicesScreen> createState() =>
      _PurchaseInvoicesScreenState();
}

class _PurchaseInvoicesScreenState
    extends ConsumerState<PurchaseInvoicesScreen> {
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(purchasesAndPaymentsProvider);
    final selectedDate = ref.watch(purchaseDateFilterProvider);

    return GradientScaffold(
      appBar: AppTopBar(
        title: _lang(context, 'فواتير المشتريات', 'Purchase Invoices'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date Filter Row
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (date != null) {
                              ref
                                      .read(purchaseDateFilterProvider.notifier)
                                      .state =
                                  date;
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            selectedDate != null
                                ? _lang(
                                    context,
                                    'تاريخ: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                                    'Date: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                                  )
                                : _lang(context, 'اختر التاريخ', 'Select Date'),
                          ),
                        ),
                      ),
                      if (selectedDate != null) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            ref
                                    .read(purchaseDateFilterProvider.notifier)
                                    .state =
                                null;
                          },
                          icon: const Icon(Icons.clear),
                          label: Text(
                            _lang(context, 'مسح الفلتر', 'Clear Filter'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Header with Add Button
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_checkout,
                      color: AppColors.blue600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _lang(
                          context,
                          'قائمة فواتير المشتريات',
                          'Purchases List',
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    GradientButton(
                      label: _lang(context, 'إضافة دفعة', 'Add Payment'),
                      icon: Icons.payment,
                      onPressed: () => _showAddGeneralPaymentDialog(),
                    ),
                    const SizedBox(width: 8),
                    GradientButton(
                      label: _lang(context, 'فاتورة جديدة', 'New Purchase'),
                      icon: Icons.add,
                      onPressed: () => _showNewPurchaseDialog(),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Purchases List
                Expanded(
                  child: purchasesAsync.when(
                    data: (purchases) {
                      if (purchases.isEmpty) {
                        return AppCard(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  _lang(
                                    context,
                                    'لا توجد فواتير مشتريات',
                                    'No purchase invoices',
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: purchases.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final item = purchases[index];
                          if (item.type == 'payment') {
                            return _PaymentCard(
                              payment: item,
                              formatDate: _formatDate,
                              onTap: () => _showPaymentDetails(item),
                            );
                          } else {
                            return _PurchaseOrPaymentCard(
                              item: item,
                              formatDate: _formatDate,
                              onTap: () => _showPurchaseDetails(item.id),
                            );
                          }
                        },
                      );
                    },
                    error: (error, stack) => AppCard(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              _lang(
                                context,
                                'فشل تحميل الفواتير',
                                'Failed to load invoices',
                              ),
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    loading: () => const AppCard(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showNewPurchaseDialog() async {
    showDialog(
      context: context,
      builder: (context) => const _NewPurchaseDialog(),
    ).then((_) {
      ref.invalidate(purchasesAndPaymentsProvider);
    });
  }

  Future<void> _showAddGeneralPaymentDialog() async {
    final suppliersAsync = await ref.read(suppliersProvider.future);

    if (!mounted) return;

    if (suppliersAsync.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(
              context,
              'لا يوجد موردين. أضف مورد أولاً',
              'No suppliers found. Add a supplier first',
            ),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _AddGeneralPaymentDialog(suppliers: suppliersAsync),
    ).then((result) {
      if (result == true) {
        ref.invalidate(purchasesAndPaymentsProvider);
      }
    });
  }

  Future<void> _showPurchaseDetails(String purchaseId) async {
    final purchaseAsync = await ref.read(
      purchaseDetailsProvider(purchaseId).future,
    );

    if (!mounted) return;

    if (purchaseAsync == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(context, 'فشل تحميل الفاتورة', 'Failed to load invoice'),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) =>
          _PurchaseDetailsDialog(purchaseWithItems: purchaseAsync),
    );
  }

  Future<void> _showPaymentDetails(PurchaseOrPayment payment) async {
    final wasReversed = await showDialog<bool>(
      context: context,
      builder: (context) => _PaymentDetailsDialog(payment: payment),
    );

    if (wasReversed == true) {
      ref.invalidate(purchasesAndPaymentsProvider);

      if (payment.supplierId != null) {
        ref.invalidate(supplierPaymentsProvider(payment.supplierId!));
        ref.invalidate(supplierTotalPaymentsProvider(payment.supplierId!));
        ref.invalidate(supplierSummaryProvider(payment.supplierId!));
        ref.invalidate(supplierPurchasesAndPaymentsProvider(payment.supplierId!));
      }
    }
  }
}

// Widget for displaying purchases or payments in the list
class _PurchaseOrPaymentCard extends StatelessWidget {
  final PurchaseOrPayment item;
  final String Function(DateTime) formatDate;
  final VoidCallback onTap;

  const _PurchaseOrPaymentCard({
    required this.item,
    required this.formatDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final balance = item.balance;
    final isPaid = item.isPaid;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.blue600.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(
                Icons.shopping_cart_checkout,
                color: AppColors.blue600,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.invoiceNumber ??
                        _lang(context, 'بدون رقم', 'No Invoice #'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (item.supplierName != null) ...[
                    Text(
                      item.supplierName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(item.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMoneyCents(item.total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isPaid
                        ? '\u0645\u062f\u0641\u0648\u0639\u0629'
                        : '\u0645\u062a\u0628\u0642\u064a: ${formatMoneyCents(balance)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPaid
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for displaying general payments (no invoice)
class _PaymentCard extends StatelessWidget {
  final PurchaseOrPayment payment;
  final String Function(DateTime) formatDate;
  final VoidCallback onTap;

  const _PaymentCard({
    required this.payment,
    required this.formatDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                Icons.payment,
                color: Colors.green.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _lang(context, 'دفعة للمورد', 'Payment to Supplier'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (payment.supplierName != null) ...[
                    Text(
                      payment.supplierName!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  if (payment.description != null &&
                      payment.description!.isNotEmpty) ...[
                    Text(
                      payment.description!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                  ],
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(payment.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMoneyCents(payment.total),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '\u0645\u062f\u0641\u0648\u0639',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseDetailsDialog extends ConsumerWidget {
  final PurchaseWithItems purchaseWithItems;

  const _PurchaseDetailsDialog({required this.purchaseWithItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void printPurchase() {
      // Show print dialog
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(_lang(context, 'طباعة الفاتورة', 'Print Invoice')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _lang(
                  context,
                  'سيتم طباعة فاتورة الشراء برقم: ${purchaseWithItems.purchase.invoiceNumber}',
                  'Will print invoice #${purchaseWithItems.purchase.invoiceNumber}',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _lang(context, 'اختر خيار الطباعة:', 'Choose print option:'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(_lang(context, 'إلغاء', 'Cancel')),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال الفاتورة للطباعة')),
                );
              },
              icon: const Icon(Icons.print),
              label: Text(_lang(context, 'طباعة', 'Print')),
            ),
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width < 820
            ? MediaQuery.of(context).size.width * 0.94
            : 700,
        constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height * 0.88)
              .clamp(420.0, 600.0)
              .toDouble(),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue600, AppColors.blue700],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _lang(context, 'تفاصيل الفاتورة', 'Purchase Details'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info rows
                    _InfoRow(
                      label: _lang(context, 'رقم الفاتورة', 'Invoice #'),
                      value: purchaseWithItems.purchase.invoiceNumber ?? '-',
                    ),
                    if (purchaseWithItems.supplier != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(
                        label: _lang(context, 'المورد', 'Supplier'),
                        value: purchaseWithItems.supplier!.name,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    _InfoRow(
                      label: _lang(context, 'التاريخ', 'Date'),
                      value:
                          '${purchaseWithItems.purchase.createdAt.year}-${purchaseWithItems.purchase.createdAt.month.toString().padLeft(2, '0')}-${purchaseWithItems.purchase.createdAt.day.toString().padLeft(2, '0')}',
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),

                    // Items table
                    Text(
                      _lang(context, 'الأصناف', 'Items'),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppRadius.sm),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _lang(context, 'المنتج', 'Product'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _lang(context, 'الكمية', 'Qty'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _lang(context, 'السعر', 'Price'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _lang(context, 'المجموع', 'Total'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Rows
                          ...purchaseWithItems.items.asMap().entries.map((
                            entry,
                          ) {
                            final item = entry.value;
                            return Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (item.product.imagePath != null &&
                                            item.product.imagePath!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                child: Image.file(
                                                  File(item.product.imagePath!),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Container(
                                                        color: Colors
                                                            .grey
                                                            .shade200,
                                                        child: const Icon(
                                                          Icons.broken_image,
                                                          size: 16,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${item.item.qty}',
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      formatMoneyCents(item.item.unitCost),
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      formatMoneyCents(item.item.lineTotal),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Totals
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.blue600.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_lang(context, 'الإجمالي', 'Total')),
                              Text(
                                formatMoneyCents(
                                  purchaseWithItems.purchase.total,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_lang(context, 'المدفوع', 'Paid')),
                              Text(
                                formatMoneyCents(
                                  purchaseWithItems.purchase.paid,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_lang(context, 'المتبقي', 'Balance')),
                              Text(
                                formatMoneyCents(
                                  purchaseWithItems.purchase.total -
                                      purchaseWithItems.purchase.paid,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: printPurchase,
                    icon: const Icon(Icons.print),
                    label: Text(_lang(context, 'طباعة', 'Print')),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(_lang(context, 'إغلاق', 'Close')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// Payment Details Dialog
class _PaymentDetailsDialog extends ConsumerWidget {
  final PurchaseOrPayment payment;

  const _PaymentDetailsDialog({required this.payment});

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void printPayment() {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(_lang(context, 'طباعة الدفعة', 'Print Payment')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _lang(
                  context,
                  'سيتم طباعة إيصال الدفعة للمورد: ${payment.supplierName ?? "غير محدد"}',
                  'Will print payment receipt for: ${payment.supplierName ?? "Unknown"}',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _lang(
                  context,
                  'المبلغ: ${formatMoneyCents(payment.total)}',
                  'Amount: ${formatMoneyCents(payment.total)}',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(_lang(context, 'إلغاء', 'Cancel')),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _lang(
                        context,
                        'تم إرسال الإيصال للطباعة',
                        'Receipt sent to print',
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.print),
              label: Text(_lang(context, 'طباعة', 'Print')),
            ),
          ],
        ),
      );
    }

    Future<void> reversePayment() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(_lang(context, 'إرجاع الدفعة', 'Reverse Payment')),
          content: Text(
            _lang(
              context,
              'هل أنت متأكد من إرجاع هذه الدفعة؟ سيتم خصمها من سجل الدفعات.',
              'Are you sure you want to reverse this payment? It will be removed from payment records.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(_lang(context, 'إلغاء', 'Cancel')),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.undo),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              label: Text(_lang(context, 'إرجاع', 'Reverse')),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      try {
        final db = ref.read(dbProvider);
        final success = await db.cancelPurchasePayment(payment.id);

        if (!context.mounted) return;

        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _lang(
                  context,
                  'تعذر إرجاع الدفعة',
                  'Failed to reverse payment',
                ),
              ),
            ),
          );
          return;
        }

        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(context, 'تم إرجاع الدفعة بنجاح', 'Payment reversed successfully'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(
                context,
                'حدث خطأ أثناء إرجاع الدفعة',
                'An error occurred while reversing payment',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width < 620
            ? MediaQuery.of(context).size.width * 0.9
            : 500,
        constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height * 0.85)
              .clamp(360.0, 500.0)
              .toDouble(),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade700],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payment, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _lang(context, 'تفاصيل الدفعة', 'Payment Details'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Info Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _lang(context, 'المورد', 'Supplier'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                payment.supplierName ?? 'غير محدد',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _lang(context, 'التاريخ', 'Date'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                _formatDate(payment.createdAt),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _lang(context, 'المبلغ', 'Amount'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                formatMoneyCents(payment.total),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          if (payment.description != null &&
                              payment.description!.isNotEmpty) ...[
                            const Divider(height: 20),
                            Text(
                              _lang(context, 'الملاحظات', 'Notes'),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              payment.description!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: reversePayment,
                    icon: const Icon(Icons.undo),
                    label: Text(_lang(context, 'إرجاع', 'Reverse')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: printPayment,
                    icon: const Icon(Icons.print),
                    label: Text(_lang(context, 'طباعة', 'Print')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(_lang(context, 'إغلاق', 'Close')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewPurchaseDialog extends ConsumerStatefulWidget {
  const _NewPurchaseDialog();

  @override
  ConsumerState<_NewPurchaseDialog> createState() => _NewPurchaseDialogState();
}

class _NewPurchaseDialogState extends ConsumerState<_NewPurchaseDialog> {
  final _invoiceNumberController = TextEditingController();
  final _paidController = TextEditingController(text: '0');
  String? _selectedSupplierId;
  final List<_PurchaseLineItem> _lineItems = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  int _parseMoneyToIlsCents(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    final normalized = trimmed.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return 0;
    return (parsed * 100).round();
  }

  void _addLineItem() {
    setState(() {
      _lineItems.add(_PurchaseLineItem());
    });
  }

  void _removeLineItem(int index) {
    setState(() {
      _lineItems.removeAt(index);
    });
  }

  int _calculateTotal() {
    return _lineItems.fold(0, (sum, item) => sum + item.lineTotal);
  }

  Future<void> _save() async {
    if (_lineItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add at least one item')));
      return;
    }

    for (final item in _lineItems) {
      if (item.productId.isEmpty || item.quantity <= 0 || item.unitCost <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all item details')),
        );
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final db = ref.read(dbProvider);
      final items = _lineItems
          .map(
            (item) => PurchaseItemInput(
              productId: item.productId,
              qty: item.quantity,
              unitCost: item.unitCost,
              lineTotal: item.lineTotal,
            ),
          )
          .toList();

      await db.createPurchase(
        supplierId: _selectedSupplierId,
        invoiceNumber: _invoiceNumberController.text.isEmpty
            ? null
            : _invoiceNumberController.text,
        items: items,
        paid: _parseMoneyToIlsCents(_paidController.text),
      );

      ref.invalidate(purchasesProvider);

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase created successfully')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(suppliersProvider);
    final total = _calculateTotal();
    final paid = _parseMoneyToIlsCents(_paidController.text);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: MediaQuery.of(context).size.width < 980
            ? MediaQuery.of(context).size.width * 0.96
            : 900,
        constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height * 0.9)
              .clamp(460.0, 700.0)
              .toDouble(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue600, AppColors.blue700],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _lang(
                        context,
                        'فاتورة شراء جديدة',
                        'New Purchase Invoice',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Supplier and Invoice Number
                    Row(
                      children: [
                        Expanded(
                          child: suppliersAsync.when(
                            data: (suppliers) =>
                                DropdownButtonFormField<String?>(
                                  initialValue: _selectedSupplierId,
                                  decoration: InputDecoration(
                                    labelText: 'المورد (Optional)',
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: null,
                                      child: Text(
                                        _lang(
                                          context,
                                          'بدون مورد',
                                          'No supplier',
                                        ),
                                      ),
                                    ),
                                    ...suppliers.map(
                                      (s) => DropdownMenuItem(
                                        value: s.id,
                                        child: Text(s.name),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSupplierId = value;
                                    });
                                  },
                                ),
                            loading: () => const TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'جاري التحميل...',
                              ),
                            ),
                            error: (_, __) => TextField(
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'خطأ في التحميل',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextField(
                            controller: _invoiceNumberController,
                            decoration: InputDecoration(
                              labelText: _lang(
                                context,
                                'رقم الفاتورة',
                                'Invoice Number',
                              ),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),

                    // Line Items
                    Row(
                      children: [
                        Text(
                          _lang(context, 'الأصناف', 'Line Items'),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _addLineItem,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(_lang(context, 'إضافة', 'Add Item')),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    if (_lineItems.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: Colors.white.withOpacity(0.06)),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Center(
                          child: Text(
                            'لا توجد أصناف. اضغط "إضافة"',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._lineItems.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _LineItemRow(
                            item: entry.value,
                            index: entry.key,
                            onRemove: () => _removeLineItem(entry.key),
                            onChanged: () => setState(() {}),
                          ),
                        );
                      }),

                    const SizedBox(height: AppSpacing.lg),

                    // Totals and Payment
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _lang(context, 'الإجمالي', 'Total'),
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                formatMoneyCents(total),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _paidController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: InputDecoration(
                                    labelText: _lang(
                                      context,
                                      'المدفوع',
                                      'Paid',
                                    ),
                                    border: const OutlineInputBorder(),
                                    suffixText: '₪',
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'متبقي: ${formatMoneyCents(total - paid)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.lg),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(_lang(context, 'إلغاء', 'Cancel')),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_lang(context, 'حفظ', 'Save')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseLineItem {
  String productId = '';
  String productName = '';
  int quantity = 0;
  int unitCost = 0;
  int get lineTotal => quantity * unitCost;
}

class _LineItemRow extends ConsumerStatefulWidget {
  final _PurchaseLineItem item;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const _LineItemRow({
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  ConsumerState<_LineItemRow> createState() => _LineItemRowState();
}

class _LineItemRowState extends ConsumerState<_LineItemRow> {
  late TextEditingController _quantityController;
  late TextEditingController _unitCostController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity > 0 ? '${widget.item.quantity}' : '',
    );
    _unitCostController = TextEditingController(
      text: widget.item.unitCost > 0
          ? (widget.item.unitCost / 100).toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitCostController.dispose();
    super.dispose();
  }

  int _parseMoneyToIlsCents(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    final normalized = trimmed.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return 0;
    return (parsed * 100).round();
  }

  Future<void> _selectProduct() async {
    final db = ref.read(dbProvider);
    final products = await db.searchProducts('');

    if (!mounted) return;

    final selectedProduct = await showDialog<Product>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Product'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width < 520
              ? MediaQuery.of(context).size.width * 0.9
              : 400,
          height: (MediaQuery.of(context).size.height * 0.6)
              .clamp(260.0, 400.0)
              .toDouble(),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.category),
                onTap: () => Navigator.of(context).pop(product),
              );
            },
          ),
        ),
      ),
    );

    if (selectedProduct != null) {
      setState(() {
        widget.item.productId = selectedProduct.id;
        widget.item.productName = selectedProduct.name;
        if (widget.item.unitCost == 0) {
          widget.item.unitCost = selectedProduct.costPrice;
          _unitCostController.text = (selectedProduct.costPrice / 100)
              .toStringAsFixed(2);
        }
      });
      widget.onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          // Product Selection
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: _selectProduct,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.item.productId.isEmpty
                          ? Icons.search
                          : Icons.check_circle,
                      color: widget.item.productId.isEmpty
                          ? Colors.grey
                          : Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.item.productName.isEmpty
                            ? 'Select'
                            : widget.item.productName,
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.item.productName.isEmpty
                              ? Colors.grey.shade600
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Quantity
          SizedBox(
            width: 80,
            child: TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Qty',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (value) {
                widget.item.quantity = int.tryParse(value) ?? 0;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),

          // Unit Cost
          SizedBox(
            width: 100,
            child: TextField(
              controller: _unitCostController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Unit Cost',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                suffixText: '₪',
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (value) {
                widget.item.unitCost = _parseMoneyToIlsCents(value);
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),

          // Total
          SizedBox(
            width: 90,
            child: Text(
              formatMoneyCents(widget.item.lineTotal),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),

          // Remove Button
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }
}

// Dialog for adding a general payment to a supplier
class _AddGeneralPaymentDialog extends ConsumerStatefulWidget {
  final List<Supplier> suppliers;

  const _AddGeneralPaymentDialog({required this.suppliers});

  @override
  ConsumerState<_AddGeneralPaymentDialog> createState() =>
      _AddGeneralPaymentDialogState();
}

class _AddGeneralPaymentDialogState
    extends ConsumerState<_AddGeneralPaymentDialog> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedSupplierId;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _parseMoneyToIlsCents(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    final normalized = trimmed.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return 0;
    return (parsed * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width < 620
            ? MediaQuery.of(context).size.width * 0.9
            : 500,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.payment, color: AppColors.blue600),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _lang(
                      context,
                      'إضافة دفعة للمورد',
                      'Add Payment to Supplier',
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Supplier Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedSupplierId,
              decoration: InputDecoration(
                labelText: _lang(context, 'المورد', 'Supplier'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              items: widget.suppliers.map((supplier) {
                return DropdownMenuItem(
                  value: supplier.id,
                  child: Text(supplier.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSupplierId = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Amount Field
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: _lang(context, 'المبلغ', 'Amount'),
                hintText: _lang(context, 'أدخل المبلغ', 'Enter amount'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                prefixIcon: const Icon(Icons.money),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Description Field
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText:
                    '${_lang(context, 'الملاحظات', 'Notes')} (${_lang(context, 'اختياري', 'Optional')})',
                hintText: _lang(
                  context,
                  'أضف ملاحظات عن الدفعة',
                  'Add notes about the payment',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(_lang(context, 'إلغاء', 'Cancel')),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleSave,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_lang(context, 'حفظ', 'Save')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    // Validate
    if (_selectedSupplierId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار المورد')));
      return;
    }

    final amountStr = _amountController.text.trim();
    if (amountStr.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال المبلغ')));
      return;
    }

    final amount = _parseMoneyToIlsCents(amountStr);
    if (amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال مبلغ صحيح')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = ref.read(dbProvider);
      await db.recordPurchasePayment(
        supplierId: _selectedSupplierId!,
        amount: amount,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إضافة الدفعة بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
