import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../core/formatting/money.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_radius.dart';
import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';
import '../../../core/utils/print_service.dart';
import '../providers/invoice_providers.dart';

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

class SalesInvoicesScreen extends ConsumerWidget {
  const SalesInvoicesScreen({super.key});

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  String _dateKey(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
  }

  String _buildInvoiceNumber(DateTime date, int sequence) {
    return '${_dateKey(date)}-${sequence.toString().padLeft(3, '0')}';
  }

  Map<String, String> _buildSequentialInvoiceNumbers(
    List<SaleWithCustomer> invoices,
  ) {
    final sorted = [...invoices]
      ..sort((a, b) {
        final dateCompare = a.sale.createdAt.compareTo(b.sale.createdAt);
        if (dateCompare != 0) return dateCompare;
        return a.sale.id.compareTo(b.sale.id);
      });

    final counters = <String, int>{};
    final result = <String, String>{};

    for (final item in sorted) {
      final key = _dateKey(item.sale.createdAt);
      final sequence = (counters[key] ?? 0) + 1;
      counters[key] = sequence;
      result[item.sale.id] = _buildInvoiceNumber(item.sale.createdAt, sequence);
    }

    return result;
  }

  void _showSaleDetails(
    BuildContext context,
    WidgetRef ref,
    String saleId,
    String invoiceNumber,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          SaleDetailsDialog(saleId: saleId, invoiceNumber: invoiceNumber),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(salesInvoicesProvider);
    final selectedDate = ref.watch(salesDateFilterProvider);

    return GradientScaffold(
      appBar: AppTopBar(
        title: _lang(context, 'فواتير المبيعات', 'Sales Invoices'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary Card
                invoicesAsync.when(
                  data: (invoices) {
                    final totalCents = invoices.fold<int>(
                      0,
                      (sum, item) => sum + item.sale.total,
                    );
                    return AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: _SummaryItem(
                              icon: Icons.receipt_long,
                              label: _lang(
                                context,
                                'عدد الفواتير',
                                'Invoice Count',
                              ),
                              value: '${invoices.length}',
                              color: AppColors.blue600,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 60,
                            color: Colors.grey.shade200,
                          ),
                          Expanded(
                            child: _SummaryItem(
                              icon: Icons.account_balance_wallet,
                              label: _lang(context, 'الإجمالي', 'Total'),
                              value: formatMoneyCents(totalCents),
                              color: AppColors.green600,
                            ),
                          ),
                        ],
                      ),
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
                              'فشل تحميل ملخص الفواتير',
                              'Failed to load invoices summary',
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

                const SizedBox(height: AppSpacing.lg),

                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: AppColors.blue600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? _lang(context, 'كل التواريخ', 'All dates')
                              : '${_lang(context, 'التاريخ', 'Date')}: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            ref.read(salesDateFilterProvider.notifier).state =
                                DateTime(picked.year, picked.month, picked.day);
                          }
                        },
                        icon: const Icon(Icons.event),
                        label: Text(
                          _lang(context, 'اختيار التاريخ', 'Select Date'),
                        ),
                      ),
                      if (selectedDate != null) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            ref.read(salesDateFilterProvider.notifier).state =
                                null;
                          },
                          child: Text(_lang(context, 'إلغاء', 'Clear')),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Section Title
                Row(
                  children: [
                    const Icon(
                      Icons.list_alt,
                      color: AppColors.blue600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _lang(context, 'قائمة الفواتير', 'Invoices List'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Invoices List
                Expanded(
                  child: invoicesAsync.when(
                    data: (invoices) {
                      final invoiceNumbers = _buildSequentialInvoiceNumbers(
                        invoices,
                      );

                      if (invoices.isEmpty) {
                        return AppCard(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  _lang(
                                    context,
                                    'لا توجد فواتير',
                                    'No invoices found',
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
                        itemCount: invoices.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          final invoiceNumber =
                              invoiceNumbers[invoice.sale.id] ??
                              _buildInvoiceNumber(invoice.sale.createdAt, 1);
                          return _InvoiceCard(
                            invoice: invoice,
                            invoiceNumber: invoiceNumber,
                            onTap: () => _showSaleDetails(
                              context,
                              ref,
                              invoice.sale.id,
                              invoiceNumber,
                            ),
                            formatDate: _formatDate,
                          );
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
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

class _InvoiceCard extends StatelessWidget {
  final SaleWithCustomer invoice;
  final String invoiceNumber;
  final VoidCallback onTap;
  final String Function(DateTime) formatDate;

  const _InvoiceCard({
    required this.invoice,
    required this.invoiceNumber,
    required this.onTap,
    required this.formatDate,
  });

  Color _getPaymentColor(String paymentType) {
    switch (paymentType) {
      case 'Cash':
        return AppColors.green600;
      case 'Card':
        return AppColors.blue600;
      case 'Transfer':
        return AppColors.purple600;
      case 'Credit':
        return AppColors.yellow600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerName =
        invoice.customer?.name ?? _lang(context, 'بدون عميل', 'No customer');
    final customerPhone = invoice.customer?.phone ?? '';

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.blue600.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(
                Icons.receipt,
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
                    '${_lang(context, 'فاتورة', 'Invoice')} #$invoiceNumber',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(invoice.sale.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        customerName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (customerPhone.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.phone,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customerPhone,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMoneyCents(invoice.sale.total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getPaymentColor(
                      invoice.sale.paymentType,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    invoice.sale.paymentType,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getPaymentColor(invoice.sale.paymentType),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class SaleDetailsDialog extends ConsumerWidget {
  final String saleId;
  final String invoiceNumber;

  const SaleDetailsDialog({super.key, required this.saleId, required this.invoiceNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(saleDetailsProvider(saleId));

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
        child: detailsAsync.when(
          data: (saleWithItems) {
            if (saleWithItems == null) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: Text('Invoice not found')),
              );
            }

            final sale = saleWithItems.sale;
            final items = saleWithItems.items;

            void showReturnDialog() {
              final controllers = <String, TextEditingController>{
                for (final item in items)
                  item.saleItem.id: TextEditingController(text: '0'),
              };

              showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      int refundTotal = 0;
                      for (final item in items) {
                        final text =
                            controllers[item.saleItem.id]?.text.trim() ?? '';
                        final qty = int.tryParse(text) ?? 0;
                        if (qty > 0) {
                          refundTotal += item.saleItem.unitPrice * qty;
                        }
                      }

                      return AlertDialog(
                        title: Text(
                          _lang(context, 'إرجاع من الفاتورة', 'Return Items'),
                        ),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width < 620
                              ? MediaQuery.of(context).size.width * 0.9
                              : 520,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    final controller =
                                        controllers[item.saleItem.id]!;

                                    return Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            item.product.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'x${item.saleItem.qty}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: controller,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Qty',
                                              isDense: true,
                                            ),
                                            onChanged: (_) => setState(() {}),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _lang(
                                      context,
                                      'قيمة الإرجاع',
                                      'Refund Amount',
                                    ),
                                  ),
                                  Text(
                                    formatMoneyCents(refundTotal),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text(_lang(context, 'إلغاء', 'Cancel')),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final returnItems = <SaleReturnItemInput>[];
                              for (final item in items) {
                                final text =
                                    controllers[item.saleItem.id]?.text
                                        .trim() ??
                                    '';
                                final qty = int.tryParse(text) ?? 0;
                                if (qty > 0) {
                                  if (qty > item.saleItem.qty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Return quantity exceeds sold quantity',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  returnItems.add(
                                    SaleReturnItemInput(
                                      saleItemId: item.saleItem.id,
                                      qty: qty,
                                    ),
                                  );
                                }
                              }

                              if (returnItems.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _lang(
                                        context,
                                        'أدخل كمية للإرجاع',
                                        'Enter return quantity',
                                      ),
                                    ),
                                  ),
                                );
                                return;
                              }

                              final db = ref.read(dbProvider);
                              final refund = await db.processSaleReturn(
                                saleId: sale.id,
                                items: returnItems,
                              );

                              ref.invalidate(saleDetailsProvider(saleId));
                              ref.invalidate(salesInvoicesProvider);

                              if (context.mounted) {
                                Navigator.of(dialogContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${_lang(context, 'تم الإرجاع', 'Returned')}: ${formatMoneyCents(refund)}',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.undo),
                            label: Text(_lang(context, 'إرجاع', 'Return')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.blue600, AppColors.blue700],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long, color: Colors.white),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _lang(context, 'تفاصيل الفاتورة', 'Invoice Details'),
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
                        // Info Section
                        _InfoRow(
                          label: _lang(context, 'رقم الفاتورة', 'Invoice #'),
                          value: invoiceNumber,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _InfoRow(
                          label: _lang(context, 'التاريخ', 'Date'),
                          value: DateFormat(
                            'yyyy-MM-dd HH:mm',
                          ).format(sale.createdAt),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _InfoRow(
                          label: _lang(context, 'طريقة الدفع', 'Payment'),
                          value: sale.paymentType,
                        ),
                        if (sale.customerId != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          FutureBuilder<Customer?>(
                            future: ref
                                .read(dbProvider)
                                .getCustomerById(sale.customerId!),
                            builder: (context, snapshot) {
                              final customer = snapshot.data;
                              final name =
                                  customer?.name ??
                                  _lang(context, 'غير معروف', 'Unknown');
                              final phone = customer?.phone ?? '-';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _InfoRow(
                                    label: _lang(context, 'العميل', 'Customer'),
                                    value: name,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  _InfoRow(
                                    label: _lang(context, 'الهاتف', 'Phone'),
                                    value: phone,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],

                        const SizedBox(height: AppSpacing.lg),
                        const Divider(),
                        const SizedBox(height: AppSpacing.md),

                        // Items Table
                        Text(
                          _lang(context, 'الأصناف', 'Items'),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(AppRadius.md),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        _lang(context, 'المنتج', 'Product'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _lang(context, 'السعر', 'Price'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _lang(context, 'الكمية', 'Qty'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _lang(context, 'الإجمالي', 'Total'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Table Rows
                              ...items.map(
                                (item) => Container(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          item.product.name,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          formatMoneyCents(
                                            item.saleItem.unitPrice,
                                          ),
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${item.saleItem.qty}',
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          formatMoneyCents(
                                            item.saleItem.lineTotal,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Totals
                        if (sale.discount > 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _lang(context, 'الخصم', 'Discount'),
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Text(
                                formatMoneyCents(sale.discount),
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.blue600.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _lang(context, 'الإجمالي', 'Total'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatMoneyCents(sale.total),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: showReturnDialog,
                                icon: const Icon(Icons.undo),
                                label: Text(_lang(context, 'إرجاع', 'Return')),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.md,
                                  ),
                                  foregroundColor: Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final printService = PrintService(
                                    ref.read(dbProvider),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _lang(
                                          context,
                                          'اضغط زر الطباعة من أعلى شاشة المعاينة',
                                          'Press the print button at the top of preview',
                                        ),
                                      ),
                                    ),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.8,
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.8,
                                        child: PdfPreview(
                                          build: (format) => printService
                                              .buildSaleInvoicePdf(sale.id),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.print),
                                label: Text(_lang(context, 'طباعة', 'Print')),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.md,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: AppErrorState(
              message: 'Failed to load invoice details',
              details: error.toString(),
              stackTrace: stack,
              onRetry: () => ref.invalidate(saleDetailsProvider(saleId)),
            ),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
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
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}
