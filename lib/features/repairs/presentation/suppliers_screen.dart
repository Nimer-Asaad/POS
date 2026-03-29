import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_button.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../data/db/app_database.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../../../providers/db_provider.dart';
import '../providers/supplier_providers.dart';
import 'supplier_requests_screen.dart';

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteSupplier(Supplier supplier) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_lang(context, 'تأكيد الحذف', 'Confirm deletion')),
        content: Text(
          _lang(
            context,
            'هل أنت متأكد من حذف المورد "${supplier.name}"؟\n\nسيتم حذف جميع الفواتير والأصناف المرتبطة به.',
            'Are you sure you want to delete supplier "${supplier.name}"?\n\nAll linked invoices and items will be removed.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_lang(context, 'إلغاء', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(_lang(context, 'حذف', 'Delete')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Delete the supplier
    final db = ref.read(dbProvider);
    final success = await db.deleteSupplier(supplier.id);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(
                context,
                'تم حذف المورد بنجاح',
                'Supplier deleted successfully',
              ),
            ),
          ),
        );
        // Refresh the suppliers list
        Future.microtask(() => ref.invalidate(suppliersProvider));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(context, 'فشل حذف المورد', 'Failed to delete supplier'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showSupplierDetails(Supplier supplier) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final summaryAsync = ref.watch(
              supplierSummaryProvider(supplier.id),
            );
            final purchasesAndPaymentsAsync = ref.watch(
              supplierPurchasesAndPaymentsProvider(supplier.id),
            );

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(supplier.name),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width < 920
                    ? MediaQuery.of(context).size.width * 0.94
                    : 800,
                height: (MediaQuery.of(context).size.height * 0.82)
                    .clamp(420.0, 600.0)
                    .toDouble(),
                child: summaryAsync.when(
                  data: (summary) {
                    if (summary == null) {
                      return Center(
                        child: Text(
                          _lang(context, 'لا توجد بيانات', 'No data'),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Supplier info header
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _lang(
                                      context,
                                      'معلومات المورد',
                                      'Supplier Info',
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: summary.balance > 0
                                          ? Colors.red.shade100
                                          : Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_lang(context, 'الرصيد', 'Balance')}: ₪${(summary.balance / 100).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: summary.balance > 0
                                            ? Colors.red.shade700
                                            : Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_lang(context, 'الهاتف', 'Phone')}: ${supplier.phone ?? '-'}',
                              ),
                              Text(
                                '${_lang(context, 'العنوان', 'Address')}: ${supplier.address ?? '-'}',
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        summary.totalInvoices.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _lang(context, 'الفواتير', 'Invoices'),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        summary.totalItems.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _lang(context, 'الأصناف', 'Items'),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '₪${(summary.totalPurchased / 100).toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _lang(context, 'الإجمالي', 'Total'),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '₪${(summary.totalPaid / 100).toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _lang(context, 'المدفوع', 'Paid'),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(this.context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SupplierRequestsScreen(
                                          supplier: supplier,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.playlist_add_check),
                                  label: Text(
                                    _lang(
                                      context,
                                      'طلبات الزبائن',
                                      'Customer requests',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Purchases and Payments header
                        Text(
                          _lang(context, 'الفواتير', 'Invoices'),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Purchases and Payments list
                        Expanded(
                          child: purchasesAndPaymentsAsync.when(
                            data: (items) {
                              if (items.isEmpty) {
                                return Center(
                                  child: Text(
                                    _lang(
                                      context,
                                      'لا توجد فواتير أو دفعات',
                                      'No invoices or payments',
                                    ),
                                  ),
                                );
                              }

                              return ListView.separated(
                                separatorBuilder: (_, __) => const Divider(),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];

                                  if (item.type == 'payment') {
                                    // Display payment
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.payment,
                                              color: Colors.green.shade700,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _lang(
                                                    context,
                                                    'دفعة',
                                                    'Payment',
                                                  ),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.green.shade700,
                                                  ),
                                                ),
                                                Text(
                                                  item.createdAt
                                                      .toString()
                                                      .split(' ')[0],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                if (item.description != null &&
                                                    item
                                                        .description!
                                                        .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 4,
                                                        ),
                                                    child: Text(
                                                      item.description!,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '₪${(item.total / 100).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    // Display purchase (invoice)
                                    final balance = item.balance;
                                    final isPaid = item.isPaid;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${_lang(context, 'فاتورة', 'Invoice')} #${item.invoiceNumber ?? item.id.substring(0, 8)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    item.createdAt
                                                        .toString()
                                                        .split(' ')[0],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '₪${(item.total / 100).toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  if (!isPaid)
                                                    Text(
                                                      '${_lang(context, 'المتبقي', 'Remaining')}: ₪${(balance / 100).toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        color:
                                                            Colors.red.shade600,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  else
                                                    Text(
                                                      _lang(
                                                        context,
                                                        'مدفوعة',
                                                        'Paid',
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            error: (error, stack) => Center(
                              child: Text(
                                '${_lang(context, 'خطأ', 'Error')}: $error',
                              ),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stack) => Center(
                    child: Text(
                      '${_lang(context, 'خطأ في تحميل البيانات', 'Failed to load data')}: $error',
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSupplierDialog({Supplier? supplier}) async {
    final isEditing = supplier != null;
    final nameController = TextEditingController(text: supplier?.name ?? '');
    final phoneController = TextEditingController(text: supplier?.phone ?? '');
    final addressController = TextEditingController(
      text: supplier?.address ?? '',
    );
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEditing
                    ? _lang(context, 'تعديل مورد', 'Edit Supplier')
                    : _lang(context, 'إضافة مورد', 'Add Supplier'),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width < 520
                    ? MediaQuery.of(context).size.width * 0.9
                    : 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: _lang(
                          context,
                          'اسم المورد *',
                          'Supplier Name *',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: _lang(context, 'الهاتف', 'Phone'),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: _lang(context, 'العنوان', 'Address'),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(_lang(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final name = nameController.text.trim();
                          if (name.isEmpty) return;

                          setDialogState(() => isSaving = true);

                          try {
                            final db = ref.read(dbProvider);
                            if (isEditing) {
                              await db.updateSupplier(
                                id: supplier.id,
                                name: name,
                                phone: phoneController.text.isEmpty
                                    ? null
                                    : phoneController.text,
                                address: addressController.text.isEmpty
                                    ? null
                                    : addressController.text,
                              );
                            } else {
                              await db.createSupplier(
                                name: name,
                                phone: phoneController.text.isEmpty
                                    ? null
                                    : phoneController.text,
                                address: addressController.text.isEmpty
                                    ? null
                                    : addressController.text,
                              );
                            }

                            ref.invalidate(suppliersProvider);
                            if (!mounted) return;
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEditing
                                      ? _lang(
                                          context,
                                          'تم تحديث المورد',
                                          'Supplier updated',
                                        )
                                      : _lang(
                                          context,
                                          'تم إضافة المورد',
                                          'Supplier added',
                                        ),
                                ),
                              ),
                            );
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${_lang(context, 'فشل العملية', 'Operation failed')}: $e',
                                  ),
                                ),
                              );
                            }
                          } finally {
                            setDialogState(() => isSaving = false);
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_lang(context, 'حفظ', 'Save')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddMissingProductDialog() async {
    final itemController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final noteController = TextEditingController();
    var isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                _lang(
                  context,
                  'قطعة ناقصة (عامة)',
                  'Global missing item',
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width < 520
                    ? MediaQuery.of(context).size.width * 0.9
                    : 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: itemController,
                      decoration: InputDecoration(
                        labelText: _lang(context, 'اسم القطعة *', 'Item name *'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _lang(context, 'الكمية', 'Quantity'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: _lang(
                          context,
                          'تفاصيل الزبون (اختياري)',
                          'Customer details (optional)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.of(context).pop(),
                  child: Text(_lang(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final itemName = itemController.text.trim();
                          if (itemName.isEmpty) return;

                          final quantity =
                              int.tryParse(quantityController.text.trim()) ?? 1;

                          setDialogState(() => isSaving = true);
                          try {
                            final db = ref.read(dbProvider);
                            await db.createMissingProductNote(
                              itemName: itemName,
                              requestedQty: quantity,
                              customerNote: noteController.text.trim().isEmpty
                                  ? null
                                  : noteController.text.trim(),
                            );
                            ref.invalidate(missingProductsNotesProvider);
                            if (!mounted) return;
                            Navigator.of(context).pop();
                          } finally {
                            setDialogState(() => isSaving = false);
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_lang(context, 'حفظ', 'Save')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _toggleMissingProductStatus(MissingProductNote note) async {
    final db = ref.read(dbProvider);
    final nextStatus = note.status == 'open' ? 'done' : 'open';
    await db.updateMissingProductNoteStatus(id: note.id, status: nextStatus);
    ref.invalidate(missingProductsNotesProvider);
  }

  Future<void> _deleteMissingProductNote(MissingProductNote note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_lang(context, 'حذف', 'Delete')),
        content: Text(
          _lang(
            context,
            'حذف القطعة "${note.itemName}"؟',
            'Delete "${note.itemName}"?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_lang(context, 'إلغاء', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(_lang(context, 'حذف', 'Delete')),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final db = ref.read(dbProvider);
    await db.deleteMissingProductNote(note.id);
    ref.invalidate(missingProductsNotesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(suppliersProvider);
    final missingStatus = ref.watch(missingProductsStatusFilterProvider);
    final missingNotesAsync = ref.watch(
      missingProductsNotesProvider(missingStatus),
    );

    return GradientScaffold(
      appBar: AppTopBar(title: _lang(context, 'الموردون', 'Suppliers')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;

                final missingPanel = _MissingProductsPanel(
                  statusFilter: missingStatus,
                  notesAsync: missingNotesAsync,
                  onAddPressed: _showAddMissingProductDialog,
                  onStatusChanged: (value) {
                    ref.read(missingProductsStatusFilterProvider.notifier).state =
                        value;
                  },
                  onToggleStatus: _toggleMissingProductStatus,
                  onDelete: _deleteMissingProductNote,
                );

                final suppliersSection = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                // Search and Add Button
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: _lang(
                              context,
                              'بحث عن مورد',
                              'Search supplier',
                            ),
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            ref
                                    .read(suppliersSearchQueryProvider.notifier)
                                    .state =
                                value;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    GradientButton(
                      label: _lang(context, 'إضافة', 'Add'),
                      icon: Icons.add,
                      onPressed: () => _showSupplierDialog(),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Suppliers List
                Expanded(
                  child: suppliersAsync.when(
                    data: (suppliers) {
                      if (suppliers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                _lang(
                                  context,
                                  'لا توجد موردون',
                                  'No suppliers found',
                                ),
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: suppliers.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final supplier = suppliers[index];
                          return AppCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: ListTile(
                              onTap: () => _showSupplierDetails(supplier),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.purple600.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.local_shipping,
                                  color: AppColors.purple600,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                supplier.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (supplier.phone != null &&
                                      supplier.phone!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(supplier.phone!),
                                    ),
                                  if (supplier.address != null &&
                                      supplier.address!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(supplier.address!),
                                    ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: _lang(
                                      context,
                                      'طلبات الزبائن',
                                      'Customer requests',
                                    ),
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SupplierRequestsScreen(
                                          supplier: supplier,
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(Icons.playlist_add_check),
                                  ),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text(
                                      _lang(
                                        context,
                                        'طلبات الزبائن',
                                        'Customer requests',
                                      ),
                                    ),
                                    onTap: () => Future.delayed(
                                      Duration.zero,
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => SupplierRequestsScreen(
                                            supplier: supplier,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      _lang(context, 'تعديل', 'Edit'),
                                    ),
                                    onTap: () => Future.delayed(
                                      Duration.zero,
                                      () => _showSupplierDialog(
                                        supplier: supplier,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      _lang(context, 'حذف', 'Delete'),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () => Future.delayed(
                                      Duration.zero,
                                      () => _deleteSupplier(supplier),
                                    ),
                                  ),
                                    ],
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stack) => Center(
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
                              'فشل تحميل الموردون',
                              'Failed to load suppliers',
                            ),
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
                  ],
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 260, child: missingPanel),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: suppliersSection),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    missingPanel,
                    const SizedBox(height: AppSpacing.lg),
                    Expanded(child: suppliersSection),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MissingProductsPanel extends StatelessWidget {
  final String? statusFilter;
  final AsyncValue<List<MissingProductNote>> notesAsync;
  final VoidCallback onAddPressed;
  final ValueChanged<String?> onStatusChanged;
  final Future<void> Function(MissingProductNote note) onToggleStatus;
  final Future<void> Function(MissingProductNote note) onDelete;

  const _MissingProductsPanel({
    required this.statusFilter,
    required this.notesAsync,
    required this.onAddPressed,
    required this.onStatusChanged,
    required this.onToggleStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _lang(context, 'النواقص (ملاحظات)', 'Missing items (notes)'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: statusFilter,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: const OutlineInputBorder(),
                    labelText: _lang(context, 'الحالة', 'Status'),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(_lang(context, 'الكل', 'All')),
                    ),
                    DropdownMenuItem(
                      value: 'open',
                      child: Text(_lang(context, 'مفتوح', 'Open')),
                    ),
                    DropdownMenuItem(
                      value: 'done',
                      child: Text(_lang(context, 'تم', 'Done')),
                    ),
                  ],
                  onChanged: onStatusChanged,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: onAddPressed,
                  tooltip: _lang(context, 'إضافة', 'Add'),
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: notesAsync.when(
              data: (notes) {
                if (notes.isEmpty) {
                  return SizedBox(
                    child: Center(
                      child: Text(
                        _lang(context, 'ما في نواقص حالياً', 'No missing items yet'),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const Divider(height: 0.5),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final isDone = note.status == 'done';
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0,
                      ),
                      leading: SizedBox(
                        width: 24,
                        child: IconButton(
                          onPressed: () => onToggleStatus(note),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isDone
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isDone ? Colors.green : Colors.grey,
                            size: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        '${note.itemName}',
                        style: TextStyle(
                          fontSize: 12,
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (note.customerNote != null &&
                              note.customerNote!.trim().isNotEmpty)
                            Text(
                              note.customerNote!,
                              style: const TextStyle(fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            DateFormat('MM-dd').format(note.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 24,
                        child: IconButton(
                          onPressed: () => onDelete(note),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 16),
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stack) => Center(
                child: Text('${_lang(context, 'خطأ', 'Error')}: $error'),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
