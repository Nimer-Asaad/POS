import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../core/formatting/money.dart';
import '../../../core/constants/responsive_breakpoints.dart';
import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';
import 'package:pos_store/l10n/app_localizations.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/ui/widgets/responsive_dialog.dart';
import '../../../core/utils/print_service.dart';
import '../../dashboard/providers/dashboard_provider.dart';

final repairStatusFilterProvider = StateProvider<String>((ref) => 'All');

final repairsProvider = FutureProvider.autoDispose<List<Repair>>((ref) async {
  final db = ref.watch(dbProvider);
  final status = ref.watch(repairStatusFilterProvider);

  if (status == 'All') {
    return db.getRepairs();
  }
  return (await db.getRepairs()).where((r) => r.status == status).toList();
});

final repairProductsProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final db = ref.watch(dbProvider);
  return db.searchProducts('');
});

final repairCustomersProvider = StreamProvider.autoDispose<List<Customer>>((
  ref,
) {
  final db = ref.watch(dbProvider);
  return db.watchCustomers('');
});

final selectedRepairProvider = StateProvider<String?>((ref) => null);

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

final repairPartsProvider = FutureProvider.autoDispose
    .family<List<RepairPartWithProduct>, String>((ref, repairId) async {
      final db = ref.watch(dbProvider);
      return db.getRepairParts(repairId);
    });

class RepairsScreen extends ConsumerStatefulWidget {
  const RepairsScreen({super.key});

  @override
  ConsumerState<RepairsScreen> createState() => _RepairsScreenState();
}

class _RepairsScreenState extends ConsumerState<RepairsScreen> {
  static const List<String> _statusOptions = [
    'All',
    'Received',
    'Diagnosing',
    'Waiting Parts',
    'Fixing',
    'Ready',
    'Delivered',
  ];

  final TextEditingController _partsSearchController = TextEditingController();
  List<Product> _filteredParts = [];

  @override
  void dispose() {
    _partsSearchController.dispose();
    super.dispose();
  }

  String _shortId(String id) => id.length <= 6 ? id : id.substring(0, 6);
  String _formatCents(int cents) => formatMoneyCents(cents);

  int _parseShekelsToCents(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    final normalized = trimmed.replaceAll(',', '.');
    final parsed = double.tryParse(normalized) ?? 0;
    return (parsed * 100).round();
  }

  String _centsToShekelsInput(int cents) {
    final value = cents ~/ 100;
    return value.toString();
  }

  void _searchParts(String query) async {
    if (query.isEmpty) {
      setState(() => _filteredParts = []);
      return;
    }

    final db = ref.read(dbProvider);
    final results = await db.searchProducts(query);
    setState(() => _filteredParts = results);
  }

  Future<void> _showPhase1NewRepairDialog() async {
    final customerNameController = TextEditingController();
    final customerPhoneController = TextEditingController();
    final deviceController = TextEditingController();
    final modelController = TextEditingController();
    final imeiController = TextEditingController();
    final issueController = TextEditingController();
    final estimatedCostController = TextEditingController(text: '0');
    final paidAtReceiveController = TextEditingController(text: '0');

    String? selectedCustomerId;
    bool isSaving = false;
    bool shouldPrintTicket = true;

    try {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              final l10n = AppLocalizations.of(context)!;
              final customersAsync = ref.watch(repairCustomersProvider);
              final customers = customersAsync.maybeWhen(
                data: (list) => list,
                orElse: () => const <Customer>[],
              );
              final nameQuery = customerNameController.text
                  .trim()
                  .toLowerCase();
              final customerSuggestions = nameQuery.isEmpty
                  ? const <Customer>[]
                  : customers
                        .where(
                          (customer) =>
                              customer.name.toLowerCase().contains(nameQuery) ||
                              ((customer.phone ?? '').toLowerCase().contains(
                                nameQuery,
                              )),
                        )
                        .take(6)
                        .toList();

              return AlertDialog(
                title: Text(l10n.newRepair),
                content: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveBreakpoints.maxDialogWidth,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: customerNameController,
                          onChanged: (_) {
                            setDialogState(() {
                              selectedCustomerId = null;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Customer Name *',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        if (customerSuggestions.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 170),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: customerSuggestions.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final customer = customerSuggestions[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(customer.name),
                                  subtitle: customer.phone == null
                                      ? null
                                      : Text(customer.phone!),
                                  onTap: () {
                                    setDialogState(() {
                                      selectedCustomerId = customer.id;
                                      customerNameController.text =
                                          customer.name;
                                      customerPhoneController.text =
                                          customer.phone ?? '';
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        TextField(
                          controller: customerPhoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: deviceController,
                          decoration: InputDecoration(
                            labelText: l10n.device,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: modelController,
                          decoration: InputDecoration(
                            labelText: l10n.model,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: imeiController,
                          decoration: InputDecoration(
                            labelText: l10n.imeiOptional,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: issueController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: l10n.issueDescription,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: estimatedCostController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Estimated Cost (₪)',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: paidAtReceiveController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Paid at Receive (₪)',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Print ticket after save'),
                          value: shouldPrintTicket,
                          onChanged: (value) {
                            setDialogState(() {
                              shouldPrintTicket = value ?? true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            final customerName = customerNameController.text
                                .trim();
                            final device = deviceController.text.trim();
                            final issue = issueController.text.trim();

                            if (customerName.isEmpty ||
                                device.isEmpty ||
                                issue.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Customer name, device, and issue required',
                                  ),
                                ),
                              );
                              return;
                            }

                            setDialogState(() {
                              isSaving = true;
                            });

                            try {
                              final db = ref.read(dbProvider);
                              final inputPhone =
                                  customerPhoneController.text.trim().isEmpty
                                  ? null
                                  : customerPhoneController.text.trim();
                              String? resolvedCustomerId = selectedCustomerId;
                              String? resolvedCustomerPhone = inputPhone;

                              if (resolvedCustomerId != null) {
                                final existingCustomer = await db
                                    .getCustomerById(resolvedCustomerId);
                                resolvedCustomerPhone =
                                    inputPhone ?? existingCustomer?.phone;
                                await db.upsertCustomer(
                                  id: resolvedCustomerId,
                                  name: customerName,
                                  phone: resolvedCustomerPhone,
                                );
                              } else {
                                final matches = await db.searchCustomers(
                                  customerName,
                                );
                                final normalizedName = customerName
                                    .toLowerCase();

                                Customer? exactMatch;
                                for (final customer in matches) {
                                  final nameMatches =
                                      customer.name.trim().toLowerCase() ==
                                      normalizedName;
                                  final phoneMatches =
                                      inputPhone != null &&
                                      customer.phone == inputPhone;
                                  if (nameMatches || phoneMatches) {
                                    exactMatch = customer;
                                    break;
                                  }
                                }

                                if (exactMatch != null) {
                                  resolvedCustomerId = exactMatch.id;
                                  resolvedCustomerPhone =
                                      inputPhone ?? exactMatch.phone;
                                  await db.upsertCustomer(
                                    id: exactMatch.id,
                                    name: customerName,
                                    phone: resolvedCustomerPhone,
                                  );
                                } else {
                                  resolvedCustomerId = await db.upsertCustomer(
                                    name: customerName,
                                    phone: inputPhone,
                                  );
                                  resolvedCustomerPhone = inputPhone;
                                }
                              }

                              final paidAtReceive = _parseShekelsToCents(
                                paidAtReceiveController.text,
                              );

                              final repairId = await db.createRepairPhase1(
                                customerName: customerName,
                                customerPhone: resolvedCustomerPhone,
                                customerId: resolvedCustomerId,
                                device: device,
                                model: modelController.text.trim().isEmpty
                                    ? null
                                    : modelController.text.trim(),
                                imei: imeiController.text.trim().isEmpty
                                    ? null
                                    : imeiController.text.trim(),
                                issue: issue,
                                estimatedCost: _parseShekelsToCents(
                                  estimatedCostController.text,
                                ),
                                paidAtReceive: paidAtReceive,
                              );

                              if (!mounted) {
                                return;
                              }
                              Navigator.of(context).pop();

                              // Invalidate after closing dialog
                              Future.microtask(() {
                                ref.invalidate(repairsProvider);
                                ref.invalidate(dashboardDataProvider);
                              });

                              if (shouldPrintTicket) {
                                try {
                                  // Show PDF preview dialog
                                  await showDialog(
                                    context: context,
                                    builder: (context) => ResponsiveDialog(
                                      child: PdfPreview(
                                        build: (format) => PrintService(
                                          db,
                                        ).buildRepairReceiptPdf(repairId),
                                        canChangeOrientation: false,
                                        canChangePageFormat: false,
                                        allowPrinting: true,
                                        allowSharing: false,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Preview failed: ${e.toString()}',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Repair received'),
                                ),
                              );
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setDialogState(() {
                                  isSaving = false;
                                });
                              }
                            }
                          },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      // Handle any errors from opening the dialog
      debugPrint('Error showing repair dialog: $e');
    } finally {
      // Dispose controllers after a short delay to avoid conflicts
      Future.delayed(const Duration(milliseconds: 100), () {
        customerNameController.dispose();
        customerPhoneController.dispose();
        deviceController.dispose();
        modelController.dispose();
        imeiController.dispose();
        issueController.dispose();
        estimatedCostController.dispose();
        paidAtReceiveController.dispose();
      });
    }
  }

  Future<void> _showPhase2DeliveryDialog(Repair repair) async {
    final finalCostController = TextEditingController(text: '0');
    final discountController = TextEditingController(text: '0');
    final paidAtDeliveryController = TextEditingController(text: '0');
    DateTime? selectedDueDate;
    bool isSaving = false;

    // Get repair parts to calculate total automatically
    final db = ref.read(dbProvider);
    List<RepairPartWithProduct> parts = [];
    int partsTotal = 0;

    try {
      parts = await db.getRepairParts(repair.id);
      partsTotal = parts.fold<int>(0, (sum, p) => sum + p.repairPart.lineTotal);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_lang(context, 'خطأ في تحميل الأجزاء', 'Failed to load parts')}: $e',
            ),
          ),
        );
      }
    }

    // Set initial final cost = estimated (labor) + parts
    finalCostController.text = _centsToShekelsInput(
      repair.estimatedCost + partsTotal,
    );

    try {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              // final l10n = AppLocalizations.of(context)!;
              final finalCost = _parseShekelsToCents(finalCostController.text);
              final discount = _parseShekelsToCents(discountController.text);
              final paidAtDelivery = _parseShekelsToCents(
                paidAtDeliveryController.text,
              );
              final total = finalCost - discount;
              final totalPaid = repair.paidAtReceive + paidAtDelivery;
              final remaining = total - totalPaid;

              return AlertDialog(
                title: const Text('Delivery - Phase 2'),
                content: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveBreakpoints.maxDialogWidth,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Show parts summary
                        if (parts.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer.withOpacity(0.3),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _lang(
                                    context,
                                    'القطع المستخدمة:',
                                    'Used parts:',
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...parts.map(
                                  (p) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${p.product.name} (${p.repairPart.qty})',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _formatCents(p.repairPart.lineTotal),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _lang(
                                        context,
                                        'مجموع القطع:',
                                        'Parts total:',
                                      ),
                                    ),
                                    Text(
                                      _formatCents(partsTotal),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _lang(
                                        context,
                                        'تكلفة العمل/الصيانة:',
                                        'Labor/Maintenance cost:',
                                      ),
                                    ),
                                    Text(
                                      _formatCents(repair.estimatedCost),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextField(
                          controller: finalCostController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          onChanged: (_) {
                            setDialogState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: 'Final Cost (₪)',
                            border: const OutlineInputBorder(),
                            helperText: _lang(
                              context,
                              'يتضمن القطع والعمل',
                              'Includes parts and labor',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: discountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          onChanged: (_) {
                            setDialogState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: 'Discount (₪)',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: paidAtDeliveryController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          onChanged: (_) {
                            setDialogState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: 'Paid at Delivery (₪)',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          title: const Text('Due Date (if remaining)'),
                          trailing: Text(
                            selectedDueDate == null
                                ? 'Select date'
                                : selectedDueDate.toString().split(' ')[0],
                          ),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                selectedDueDate = picked;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiaryContainer.withOpacity(0.3),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.tertiaryContainer,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Summary:',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Final Cost:'),
                                  Text(_formatCents(finalCost)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discount:'),
                                  Text(_formatCents(discount)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total:'),
                                  Text(_formatCents(total)),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Paid at Receive:'),
                                  Text(_formatCents(repair.paidAtReceive)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Paid at Delivery:'),
                                  Text(_formatCents(paidAtDelivery)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Paid:'),
                                  Text(_formatCents(totalPaid)),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Remaining:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _formatCents(remaining.abs()),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: remaining > 0
                                          ? Colors.red
                                          : Colors.green,
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
                actions: [
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            setDialogState(() {
                              isSaving = true;
                            });

                            try {
                              // If remaining > 0, confirm debt before proceeding
                              if (remaining > 0) {
                                final confirmDebt = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      _lang(
                                        context,
                                        'تأكيد الدين',
                                        'Debt Confirmation',
                                      ),
                                    ),
                                    content: Text(
                                      '${_lang(context, 'الباقي المستحق', 'Remaining due')}: ${_formatCents(remaining)}\n\n'
                                      '${_lang(context, 'هل تريد نقل المبلغ المتبقي إلى الديون؟', 'Do you want to move the remaining amount to debt?')}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          _lang(context, 'إلغاء', 'Cancel'),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          _lang(
                                            context,
                                            'نعم، نقل للديون',
                                            'Yes, move to debt',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDebt != true) {
                                  setDialogState(() {
                                    isSaving = false;
                                  });
                                  return;
                                }
                              }

                              await db.finalizeRepairDelivery(
                                repairId: repair.id,
                                finalCost: finalCost,
                                discount: discount,
                                paidAtDelivery: paidAtDelivery,
                                dueDate: selectedDueDate,
                              );

                              if (!mounted) {
                                return;
                              }
                              Navigator.of(context).pop();

                              // Invalidate after closing dialog
                              Future.microtask(() {
                                ref.invalidate(repairsProvider);
                                ref.invalidate(dashboardDataProvider);
                              });

                              // Show print preview immediately
                              _showDeliveryReceiptPreview(repair.id);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    remaining > 0
                                        ? '${_lang(context, 'تم التسليم وإضافة', 'Delivered and added')} ${_formatCents(remaining)} ${_lang(context, 'للديون', 'to debt')}'
                                        : _lang(
                                            context,
                                            'تم التسليم بنجاح',
                                            'Delivered successfully',
                                          ),
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setDialogState(() {
                                  isSaving = false;
                                });
                              }
                            }
                          },
                    child: const Text('Finalize'),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      // Handle any errors from opening the dialog
      debugPrint('Error showing delivery dialog: $e');
    } finally {
      // Dispose controllers after a short delay to avoid conflicts
      Future.delayed(const Duration(milliseconds: 100), () {
        finalCostController.dispose();
        discountController.dispose();
        paidAtDeliveryController.dispose();
      });
    }
  }

  void _showDeliveryReceiptPreview(String repairId) {
    final printService = PrintService(ref.read(dbProvider));

    showDialog(
      context: context,
      builder: (context) => ResponsiveDialog(
        child: PdfPreview(
          build: (format) => printService.buildDeliveryReceiptPdf(repairId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repairsAsync = ref.watch(repairsProvider);
    final statusFilter = ref.watch(repairStatusFilterProvider);

    return GradientScaffold(
      appBar: AppTopBar(title: l10n.repairs),
      body: Row(
        children: [
          // Main repairs list
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ..._statusOptions.map(
                                (status) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(status),
                                    selected: statusFilter == status,
                                    onSelected: (_) {
                                      ref
                                              .read(
                                                repairStatusFilterProvider
                                                    .notifier,
                                              )
                                              .state =
                                          status;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _showPhase1NewRepairDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('New Repair'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: repairsAsync.when(
                    data: (repairs) {
                      if (repairs.isEmpty) {
                        return const Center(child: Text('No repairs'));
                      }

                      return SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              const DataColumn(label: Text('ID')),
                              DataColumn(label: Text(l10n.customer)),
                              const DataColumn(label: Text('Device')),
                              const DataColumn(label: Text('Model')),
                              const DataColumn(label: Text('Status')),
                              const DataColumn(label: Text('Created')),
                              const DataColumn(label: Text('Remaining')),
                              DataColumn(label: const Text('Actions')),
                            ],
                            rows: repairs.map((repair) {
                              final total = repair.finalCost - repair.discount;
                              final totalPaid =
                                  repair.paidAtReceive + repair.paidAtDelivery;
                              final remaining = total - totalPaid;
                              final hasDebt =
                                  repair.status == 'Delivered' && remaining > 0;

                              return DataRow(
                                cells: [
                                  DataCell(Text(_shortId(repair.id))),
                                  DataCell(
                                    Tooltip(
                                      message: repair.customerPhone ?? '',
                                      child: Text(
                                        repair.customerName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      repair.device,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      repair.model ?? '-',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  DataCell(Chip(label: Text(repair.status))),
                                  DataCell(
                                    Text(
                                      repair.createdAt.toString().split(' ')[0],
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        Text(
                                          _formatCents(remaining.abs()),
                                          style: TextStyle(
                                            color: remaining > 0
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (hasDebt)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'DEBT',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        if (repair.status != 'Delivered')
                                          ElevatedButton(
                                            onPressed: () =>
                                                _showPhase2DeliveryDialog(
                                                  repair,
                                                ),
                                            child: const Text('Delivery'),
                                          ),
                                        const SizedBox(width: 8),
                                        PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: const Text('View Details'),
                                              onTap: () =>
                                                  _showRepairDetails(repair),
                                            ),
                                            if (repair.status != 'Delivered')
                                              PopupMenuItem(
                                                child: Text(
                                                  _lang(
                                                    context,
                                                    'حذف',
                                                    'Delete',
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    _deleteRepair(repair),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) => AppErrorState(
                      message: 'Failed to load repairs',
                      details: error.toString(),
                      stackTrace: stackTrace,
                      onRetry: () => ref.invalidate(repairsProvider),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ),

          // Parts search panel (right side)
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _lang(context, 'بحث عن القطع', 'Parts Search'),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _partsSearchController,
                        decoration: InputDecoration(
                          labelText: _lang(
                            context,
                            'اسم القطعة أو كود',
                            'Part name or code',
                          ),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.hardware),
                          hintText: _lang(
                            context,
                            'مثال: شاشة، بطارية...',
                            'Example: screen, battery...',
                          ),
                        ),
                        onChanged: _searchParts,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _filteredParts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _partsSearchController.text.isEmpty
                                    ? _lang(
                                        context,
                                        'ابحث عن قطعة للصيانة',
                                        'Search for a repair part',
                                      )
                                    : _lang(
                                        context,
                                        'لا توجد نتائج',
                                        'No results',
                                      ),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: _filteredParts.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final part = _filteredParts[index];
                            final inStock = part.qty > 0;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: inStock
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                    : Theme.of(
                                        context,
                                      ).colorScheme.errorContainer,
                                child: Icon(
                                  Icons.hardware,
                                  color: inStock
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onErrorContainer,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                part.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        size: 14,
                                        color: Colors.green.shade700,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_lang(context, 'السعر', 'Price')}: ${_formatCents(part.sellPrice)}',
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        inStock
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        size: 14,
                                        color: inStock
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onPrimaryContainer
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onErrorContainer,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        inStock
                                            ? '${_lang(context, 'الكمية', 'Qty')}: ${part.qty}'
                                            : _lang(
                                                context,
                                                'غير متوفر',
                                                'Out of stock',
                                              ),
                                        style: TextStyle(
                                          color: inStock
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimaryContainer
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onErrorContainer,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.info_outline,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () {
                                // Show more details or quick add
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(part.name),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _InfoRow(
                                          label: _lang(
                                            context,
                                            'سعر البيع',
                                            'Sale Price',
                                          ),
                                          value: _formatCents(part.sellPrice),
                                        ),
                                        _InfoRow(
                                          label: _lang(
                                            context,
                                            'سعر الشراء',
                                            'Cost Price',
                                          ),
                                          value: _formatCents(part.costPrice),
                                        ),
                                        _InfoRow(
                                          label: _lang(
                                            context,
                                            'الكمية المتوفرة',
                                            'Available Qty',
                                          ),
                                          value: '${part.qty}',
                                        ),
                                        if (part.barcode != null)
                                          _InfoRow(
                                            label: _lang(
                                              context,
                                              'الباركود',
                                              'Barcode',
                                            ),
                                            value: part.barcode!,
                                          ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          _lang(context, 'إغلاق', 'Close'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateCustomPartDialog(String repairId) async {
    final nameController = TextEditingController();
    final costController = TextEditingController();
    final supplierController = TextEditingController();
    final sellPriceController = TextEditingController();

    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add External Part'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Part Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: costController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Cost Price (₪)',
                        border: OutlineInputBorder(),
                        helperText: 'Enter as shekels (e.g. 10 = ₪10.00)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: sellPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Sell Price (₪)',
                        border: OutlineInputBorder(),
                        helperText: 'Enter as shekels (e.g. 12 = ₪12.00)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: supplierController,
                      decoration: const InputDecoration(
                        labelText: 'Supplier / Merchant',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (nameController.text.isEmpty ||
                              costController.text.isEmpty ||
                              sellPriceController.text.isEmpty ||
                              supplierController.text.isEmpty) {
                            return;
                          }

                          setDialogState(() => isSaving = true);
                          try {
                            final db = ref.read(dbProvider);
                            final productId = await db
                                .createProductWithSupplier(
                                  name: nameController.text.trim(),
                                  costPrice: _parseShekelsToCents(
                                    costController.text,
                                  ),
                                  sellPrice: _parseShekelsToCents(
                                    sellPriceController.text,
                                  ),
                                  supplierName: supplierController.text.trim(),
                                );

                            await db.addRepairPart(
                              repairId: repairId,
                              productId: productId,
                              qty: 1,
                              unitPrice: _parseShekelsToCents(
                                sellPriceController.text,
                              ),
                            );

                            if (!mounted) return;
                            Navigator.pop(context); // Close this dialog
                            Navigator.pop(
                              context,
                            ); // Close parent (Add Part) dialog

                            // Invalidate after closing dialogs
                            Future.microtask(() {
                              ref.invalidate(repairPartsProvider(repairId));
                            });
                          } catch (e) {
                            debugPrint(e.toString());
                          } finally {
                            if (mounted) setDialogState(() => isSaving = false);
                          }
                        },
                  child: const Text('Create & Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddPartDialog(String repairId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return _AddPartDialog(repairId: repairId, parentRef: ref);
      },
    );
  }

  Future<void> _deleteRepair(Repair repair) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_lang(context, 'تأكيد الحذف', 'Confirm deletion')),
        content: Text(
          _lang(
            context,
            'هل أنت متأكد من حذف إصلاح "${repair.device}" للعميل "${repair.customerName}"؟\n\nسيتم حذف جميع الأجزاء المرتبطة وإعادة المخزون.',
            'Are you sure you want to delete repair "${repair.device}" for customer "${repair.customerName}"?\n\nAll linked parts will be removed and stock restored.',
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

    // Delete the repair
    final db = ref.read(dbProvider);
    final success = await db.deleteRepair(repair.id);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(
                context,
                'تم حذف الإصلاح بنجاح',
                'Repair deleted successfully',
              ),
            ),
          ),
        );
        // Refresh the repairs list
        Future.microtask(() => ref.invalidate(repairsProvider));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(context, 'فشل حذف الإصلاح', 'Failed to delete repair'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRepairDetails(Repair repair) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final partsAsync = ref.watch(repairPartsProvider(repair.id));
            final partsTotal = partsAsync.maybeWhen(
              data: (parts) => parts.fold<int>(
                0,
                (sum, part) => sum + part.repairPart.lineTotal,
              ),
              orElse: () => 0,
            );

            // Calculate totals dynamically based on parts
            // Calculate totals dynamically based on parts
            // totalCost variable removed as it was unused.
            // final totalCost = (repair.estimatedCost + partsTotal) - repair.discount;

            // Actually, let's just show parts total and let user decide final cost in delivery.
            // But user asked for automatic calculation.
            // Let's assume estimatedCost IS the labor cost for now, or just base cost.

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Repair Details'),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveBreakpoints.maxDialogWidth,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _DetailRow(label: 'ID', value: _shortId(repair.id)),
                      _DetailRow(label: 'Customer', value: repair.customerName),
                      if (repair.customerPhone != null)
                        _DetailRow(
                          label: 'Phone',
                          value: repair.customerPhone!,
                        ),
                      const Divider(),
                      _DetailRow(label: 'Device', value: repair.device),
                      if (repair.model != null)
                        _DetailRow(label: 'Model', value: repair.model!),
                      if (repair.imei != null)
                        _DetailRow(label: 'IMEI', value: repair.imei!),
                      const SizedBox(height: 8),
                      const Text(
                        'Issue:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(repair.issue),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Parts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (repair.status != 'Delivered')
                            TextButton.icon(
                              onPressed: () => _showAddPartDialog(repair.id),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Part'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      partsAsync.when(
                        data: (parts) {
                          if (parts.isEmpty) {
                            return const Text('No parts added.');
                          }
                          return Column(
                            children: parts
                                .map(
                                  (p) => ListTile(
                                    leading: const Icon(Icons.hardware),
                                    title: Text(p.product.name),
                                    subtitle: Text(
                                      '${p.repairPart.qty} x ${_formatCents(p.repairPart.unitPrice)}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: repair.status == 'Delivered'
                                          ? null
                                          : () async {
                                              final db = ref.read(dbProvider);
                                              await db.removeRepairPart(
                                                p.repairPart.id,
                                              );

                                              // Invalidate after deletion
                                              Future.microtask(() {
                                                ref.invalidate(
                                                  repairPartsProvider(
                                                    repair.id,
                                                  ),
                                                );
                                              });
                                            },
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Text('Error: $e'),
                      ),
                      const Divider(),
                      _DetailRow(label: 'Status', value: repair.status),
                      _DetailRow(
                        label: 'Estimated Cost (Labor)',
                        value: _formatCents(repair.estimatedCost),
                      ),
                      _DetailRow(
                        label: 'Parts Total',
                        value: _formatCents(partsTotal),
                      ),
                      if (repair.finalCost > 0)
                        _DetailRow(
                          label: 'Final Cost',
                          value: _formatCents(repair.finalCost),
                        ),
                      _DetailRow(
                        label: 'Paid (Deposit)',
                        value: _formatCents(repair.paidAtReceive),
                      ),
                      if (repair.paidAtDelivery > 0)
                        _DetailRow(
                          label: 'Paid (Delivery)',
                          value: _formatCents(repair.paidAtDelivery),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                if (repair.status != 'Delivered')
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close details
                      _showPhase2DeliveryDialog(repair);
                    },
                    child: const Text('Proceed to Delivery'),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

// Separate StatefulWidget for Add Part Dialog with search
class _AddPartDialog extends ConsumerStatefulWidget {
  final String repairId;
  final WidgetRef parentRef;
  
  const _AddPartDialog({required this.repairId, required this.parentRef});

  @override
  ConsumerState<_AddPartDialog> createState() => _AddPartDialogState();
}

class _AddPartDialogState extends ConsumerState<_AddPartDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCents(int cents) {
    return '₪${(cents / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Part'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search field
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Search parts...',
                hintText: 'Search by name, barcode, or category',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Create External Part'),
              subtitle: const Text('For parts not in inventory'),
              onTap: () {
                Navigator.pop(context);
                // Call the create custom part dialog
                final state = context.findAncestorStateOfType<_RepairsScreenState>();
                state?._showCreateCustomPartDialog(widget.repairId);
              },
            ),
            const Divider(),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final productsAsync = ref.watch(repairProductsProvider);
                  return productsAsync.when(
                    data: (products) {
                      // Filter products based on search query
                      final filteredProducts = _searchQuery.isEmpty
                          ? products
                          : products.where((product) {
                              return product.name.toLowerCase().contains(_searchQuery) ||
                                  (product.barcode?.toLowerCase().contains(_searchQuery) ?? false) ||
                                  product.category.toLowerCase().contains(_searchQuery);
                            }).toList();

                      if (filteredProducts.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off, size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty 
                                    ? 'No products available' 
                                    : 'No results found for "$_searchQuery"',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: filteredProducts.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ListTile(
                            title: Text(product.name),
                            subtitle: Text(
                              'Stock: ${product.qty} | Price: ${_formatCents(product.sellPrice)}',
                            ),
                            onTap: () async {
                              final db = ref.read(dbProvider);
                              await db.addRepairPart(
                                repairId: widget.repairId,
                                productId: product.id,
                                qty: 1,
                                unitPrice: product.sellPrice,
                              );
                              if (!mounted) return;
                              Navigator.pop(context);

                              // Invalidate after closing dialog
                              Future.microtask(() {
                                ref.invalidate(
                                  repairPartsProvider(widget.repairId),
                                );
                              });
                            },
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text('Error loading products'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
