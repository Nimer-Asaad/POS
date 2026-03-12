import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/formatting/money.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/ui/widgets/gradient_button.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_radius.dart';
import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';
import '../providers/invoice_providers.dart';

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

class PurchaseInvoicesScreen extends ConsumerWidget {
  const PurchaseInvoicesScreen({super.key});

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
    List<PurchaseInvoice> invoices,
  ) {
    final sorted = [...invoices]
      ..sort((a, b) {
        final dateCompare = a.createdAt.compareTo(b.createdAt);
        if (dateCompare != 0) return dateCompare;
        return a.id.compareTo(b.id);
      });

    final counters = <String, int>{};
    final result = <String, String>{};

    for (final item in sorted) {
      final key = _dateKey(item.createdAt);
      final sequence = (counters[key] ?? 0) + 1;
      counters[key] = sequence;
      result[item.id] = _buildInvoiceNumber(item.createdAt, sequence);
    }

    return result;
  }

  void _showAddPurchaseInvoiceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const _AddPurchaseInvoiceDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(purchaseInvoicesProvider);
    final selectedDate = ref.watch(purchaseInvoicesDateFilterProvider);

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
                // Header with Add Button
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_basket,
                      color: AppColors.blue600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _lang(
                          context,
                          'قائمة فواتير المشتريات',
                          'Invoices List',
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    GradientButton(
                      label: _lang(context, 'إضافة فاتورة', 'Add Invoice'),
                      icon: Icons.add,
                      onPressed: () =>
                          _showAddPurchaseInvoiceDialog(context, ref),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: AppColors.purple600,
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
                            ref
                                .read(
                                  purchaseInvoicesDateFilterProvider.notifier,
                                )
                                .state = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                            );
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
                            ref
                                    .read(
                                      purchaseInvoicesDateFilterProvider
                                          .notifier,
                                    )
                                    .state =
                                null;
                          },
                          child: Text(_lang(context, 'إلغاء', 'Clear')),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

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
                                  Icons.shopping_basket_outlined,
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
                        itemCount: invoices.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          final invoiceNumber =
                              invoiceNumbers[invoice.id] ??
                              _buildInvoiceNumber(invoice.createdAt, 1);
                          return _PurchaseInvoiceCard(
                            invoice: invoice,
                            invoiceNumber: invoiceNumber,
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

class _PurchaseInvoiceCard extends StatelessWidget {
  final PurchaseInvoice invoice;
  final String invoiceNumber;
  final String Function(DateTime) formatDate;

  const _PurchaseInvoiceCard({
    required this.invoice,
    required this.invoiceNumber,
    required this.formatDate,
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
              color: AppColors.purple600.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: AppColors.purple600,
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
                Text(
                  '${_lang(context, 'المورد', 'Supplier')}: ${invoice.supplier}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatDate(invoice.createdAt),
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
          Text(
            formatMoneyCents(invoice.total),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.purple600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddPurchaseInvoiceDialog extends ConsumerStatefulWidget {
  const _AddPurchaseInvoiceDialog();

  @override
  ConsumerState<_AddPurchaseInvoiceDialog> createState() =>
      _AddPurchaseInvoiceDialogState();
}

class _AddPurchaseInvoiceDialogState
    extends ConsumerState<_AddPurchaseInvoiceDialog> {
  final _supplierController = TextEditingController();
  final List<_PurchaseLineItem> _lineItems = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _supplierController.dispose();
    super.dispose();
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
    return _lineItems.fold(
      0,
      (sum, item) => sum + (item.quantity * item.purchasePrice),
    );
  }

  Future<void> _save() async {
    final supplier = _supplierController.text.trim();

    if (supplier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(context, 'اسم المورد مطلوب', 'Supplier name is required'),
          ),
        ),
      );
      return;
    }

    if (_lineItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(
              context,
              'أضف صنفًا واحدًا على الأقل',
              'Add at least one item',
            ),
          ),
        ),
      );
      return;
    }

    // Validate all line items
    for (final item in _lineItems) {
      if (item.productId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(
                context,
                'اختر منتجًا لكل الأصناف',
                'Select product for all items',
              ),
            ),
          ),
        );
        return;
      }
      if (item.quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(
                context,
                'يجب أن تكون الكمية أكبر من 0',
                'Quantity must be greater than 0',
              ),
            ),
          ),
        );
        return;
      }
      if (item.purchasePrice <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(
                context,
                'يجب أن يكون سعر الشراء أكبر من 0',
                'Purchase price must be greater than 0',
              ),
            ),
          ),
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
            (item) => PurchaseInvoiceItemInput(
              productId: item.productId,
              qty: item.quantity,
              purchasePrice: item.purchasePrice,
              salePrice: item.salePrice,
              lineTotal: item.quantity * item.purchasePrice,
            ),
          )
          .toList();

      await db.createPurchaseInvoice(supplier: supplier, items: items);

      ref.invalidate(purchaseInvoicesProvider);

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(
              context,
              'تم إنشاء فاتورة المشتريات بنجاح',
              'Purchase invoice created successfully',
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_lang(context, 'فشل إنشاء الفاتورة', 'Failed to create invoice')}: $e',
            ),
          ),
        );
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
    final total = _calculateTotal();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.purple600, AppColors.purple700],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_basket, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _lang(
                        context,
                        'إضافة فاتورة مشتريات',
                        'Add Purchase Invoice',
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
                    // Invoice Info
                    TextField(
                      controller: _supplierController,
                      decoration: InputDecoration(
                        labelText: _lang(context, 'المورد *', 'Supplier *'),
                        border: const OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),

                    // Line Items Section
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
                          label: Text(_lang(context, 'إضافة صنف', 'Add Item')),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    if (_lineItems.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            _lang(
                              context,
                              'لا توجد أصناف. اضغط "إضافة" لإضافة صنف.',
                              'No items. Click "Add Item" to add one.',
                            ),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      )
                    else
                      ..._lineItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _LineItemRow(
                            item: item,
                            index: index,
                            onRemove: () => _removeLineItem(index),
                            onChanged: () => setState(() {}),
                          ),
                        );
                      }),

                    const SizedBox(height: AppSpacing.lg),

                    // Total
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.purple600.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _lang(context, 'الإجمالي', 'Total'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatMoneyCents(total),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.purple600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.lg),
                ),
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
  String barcode = '';
  String category = '';
  int quantity = 0;
  int purchasePrice = 0;
  int salePrice = 0;
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
  final _quantityController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.item.quantity > 0
        ? '${widget.item.quantity}'
        : '';
    _purchasePriceController.text = widget.item.purchasePrice > 0
        ? (widget.item.purchasePrice / 100).toStringAsFixed(2)
        : '';
    _salePriceController.text = widget.item.salePrice > 0
        ? (widget.item.salePrice / 100).toStringAsFixed(2)
        : '';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
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
        title: Text(_lang(context, 'اختر منتج', 'Select Product')),
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
                subtitle: Text(
                  '${product.barcode ?? '-'} | ${product.category}',
                ),
                onTap: () => Navigator.of(context).pop(product),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_lang(context, 'إلغاء', 'Cancel')),
          ),
        ],
      ),
    );

    if (selectedProduct != null) {
      setState(() {
        widget.item.productId = selectedProduct.id;
        widget.item.productName = selectedProduct.name;
        widget.item.barcode = selectedProduct.barcode ?? '';
        widget.item.category = selectedProduct.category;
        // Pre-fill with existing prices
        if (widget.item.purchasePrice == 0) {
          widget.item.purchasePrice = selectedProduct.costPrice;
          _purchasePriceController.text = (selectedProduct.costPrice / 100)
              .toStringAsFixed(2);
        }
        if (widget.item.salePrice == 0) {
          widget.item.salePrice = selectedProduct.sellPrice;
          _salePriceController.text = (selectedProduct.sellPrice / 100)
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.productName.isEmpty
                                ? _lang(context, 'اختر منتج', 'Select Product')
                                : widget.item.productName,
                            style: TextStyle(
                              fontSize: 13,
                              color: widget.item.productName.isEmpty
                                  ? Colors.grey.shade600
                                  : Colors.black87,
                            ),
                          ),
                          if (widget.item.barcode.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.item.barcode,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
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
          ),
          const SizedBox(width: 8),

          // Quantity
          SizedBox(
            width: 80,
            child: TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: _lang(context, 'الكمية', 'Quantity'),
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

          // Purchase Price
          SizedBox(
            width: 100,
            child: TextField(
              controller: _purchasePriceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: _lang(context, 'سعر الشراء', 'Purchase Price'),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                suffixText: '₪',
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (value) {
                widget.item.purchasePrice = _parseMoneyToIlsCents(value);
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),

          // Sale Price
          SizedBox(
            width: 100,
            child: TextField(
              controller: _salePriceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: _lang(context, 'سعر البيع', 'Sale Price'),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                suffixText: '₪',
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (value) {
                widget.item.salePrice = _parseMoneyToIlsCents(value);
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),

          // Total
          SizedBox(
            width: 90,
            child: Text(
              formatMoneyCents(
                widget.item.quantity * widget.item.purchasePrice,
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),

          // Remove Button
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            tooltip: _lang(context, 'حذف', 'Remove'),
          ),
        ],
      ),
    );
  }
}
