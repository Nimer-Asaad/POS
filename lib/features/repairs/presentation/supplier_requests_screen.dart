import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_button.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../data/db/app_database.dart';
import '../../../design/app_spacing.dart';
import '../../../providers/db_provider.dart';
import '../providers/supplier_providers.dart';

class SupplierRequestsScreen extends ConsumerStatefulWidget {
  final Supplier supplier;

  const SupplierRequestsScreen({super.key, required this.supplier});

  @override
  ConsumerState<SupplierRequestsScreen> createState() =>
      _SupplierRequestsScreenState();
}

class _SupplierRequestsScreenState extends ConsumerState<SupplierRequestsScreen> {
  String? _selectedStatus;

  String _lang(String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  ({String supplierId, String? status}) _query() {
    return (supplierId: widget.supplier.id, status: _selectedStatus);
  }

  Future<void> _showAddRequestDialog() async {
    final productController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final noteController = TextEditingController();
    var isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_lang('إضافة منتج ناقص', 'Add Missing Product')),
              content: SizedBox(
                width: MediaQuery.of(context).size.width < 520
                    ? MediaQuery.of(context).size.width * 0.9
                    : 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: productController,
                      decoration: InputDecoration(
                        labelText: _lang('اسم المنتج *', 'Product name *'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: _lang('الكمية', 'Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: _lang(
                          'ملاحظة / اسم الزبون (اختياري)',
                          'Note / customer name (optional)',
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.of(context).pop(),
                  child: Text(_lang('إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final productName = productController.text.trim();
                          final quantity =
                              int.tryParse(quantityController.text.trim()) ?? 1;

                          if (productName.isEmpty) return;

                          setDialogState(() => isSaving = true);
                          try {
                            final db = ref.read(dbProvider);
                            await db.createSupplierRequestedProduct(
                              supplierId: widget.supplier.id,
                              productName: productName,
                              requestedQty: quantity,
                              customerNote: noteController.text.trim().isEmpty
                                  ? null
                                  : noteController.text.trim(),
                            );
                            if (!mounted) return;
                            ref.invalidate(
                              supplierRequestedProductsProvider(_query()),
                            );
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _lang('تمت إضافة الطلب', 'Request added'),
                                ),
                              ),
                            );
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
                      : Text(_lang('حفظ', 'Save')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateStatus(SupplierRequestedProduct request, String status) async {
    final db = ref.read(dbProvider);
    await db.updateSupplierRequestedProductStatus(id: request.id, status: status);
    ref.invalidate(supplierRequestedProductsProvider(_query()));
  }

  Future<void> _deleteRequest(SupplierRequestedProduct request) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_lang('حذف الطلب', 'Delete request')),
        content: Text(
          _lang(
            'هل تريد حذف طلب "${request.productName}"؟',
            'Delete request "${request.productName}"?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_lang('إلغاء', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(_lang('حذف', 'Delete')),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final db = ref.read(dbProvider);
    await db.deleteSupplierRequestedProduct(request.id);
    ref.invalidate(supplierRequestedProductsProvider(_query()));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'ordered':
        return Colors.orange;
      case 'received':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'ordered':
        return _lang('تم طلبه', 'Ordered');
      case 'received':
        return _lang('وصل', 'Received');
      case 'cancelled':
        return _lang('ملغي', 'Cancelled');
      case 'pending':
      default:
        return _lang('مطلوب', 'Pending');
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(supplierRequestedProductsProvider(_query()));

    return GradientScaffold(
      appBar: AppTopBar(
        title: _lang('طلبات الزبائن - ${widget.supplier.name}', 'Customer Requests - ${widget.supplier.name}'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String?>(
                            value: _selectedStatus,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(_lang('كل الحالات', 'All statuses')),
                              ),
                              DropdownMenuItem(
                                value: 'pending',
                                child: Text(_statusLabel('pending')),
                              ),
                              DropdownMenuItem(
                                value: 'ordered',
                                child: Text(_statusLabel('ordered')),
                              ),
                              DropdownMenuItem(
                                value: 'received',
                                child: Text(_statusLabel('received')),
                              ),
                              DropdownMenuItem(
                                value: 'cancelled',
                                child: Text(_statusLabel('cancelled')),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => _selectedStatus = value);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    GradientButton(
                      label: _lang('إضافة طلب', 'Add request'),
                      icon: Icons.add,
                      onPressed: _showAddRequestDialog,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: requestsAsync.when(
                    data: (requests) {
                      if (requests.isEmpty) {
                        return Center(
                          child: Text(
                            _lang(
                              'لا توجد طلبات حالياً',
                              'No requests yet',
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: requests.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          final statusColor = _statusColor(request.status);

                          return AppCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _statusLabel(request.status),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request.productName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_lang('الكمية', 'Qty')}: ${request.requestedQty}',
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd HH:mm')
                                            .format(request.createdAt),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      if (request.customerNote != null &&
                                          request.customerNote!.trim().isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            request.customerNote!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'delete') {
                                      await _deleteRequest(request);
                                      return;
                                    }
                                    await _updateStatus(request, value);
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'pending',
                                      child: Text(_statusLabel('pending')),
                                    ),
                                    PopupMenuItem(
                                      value: 'ordered',
                                      child: Text(_statusLabel('ordered')),
                                    ),
                                    PopupMenuItem(
                                      value: 'received',
                                      child: Text(_statusLabel('received')),
                                    ),
                                    PopupMenuItem(
                                      value: 'cancelled',
                                      child: Text(_statusLabel('cancelled')),
                                    ),
                                    const PopupMenuDivider(),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        _lang('حذف', 'Delete'),
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stack) => Center(
                      child: Text('${_lang('خطأ', 'Error')}: $error'),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
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
