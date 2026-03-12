import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../core/formatting/money.dart';
import '../../../core/utils/print_service.dart';
import '../../../core/constants/responsive_breakpoints.dart';
import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/ui/widgets/responsive_dialog.dart';
import '../../../design/app_colors.dart';

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

final debtsGroupedProvider =
    FutureProvider.autoDispose<Map<String?, List<Debt>>>((ref) async {
      final db = ref.watch(dbProvider);
      return db.getAllDebtsGroupedByCustomer();
    });

// Provider for recent payments of a specific customer
final recentPaymentsProvider = FutureProvider.autoDispose
    .family<List<Payment>, String>((ref, customerId) async {
      final db = ref.watch(dbProvider);
      return db.getRecentPaymentsForCustomer(customerId, limit: 10000);
    });

class DebtsScreen extends ConsumerStatefulWidget {
  const DebtsScreen({super.key});

  @override
  ConsumerState<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends ConsumerState<DebtsScreen> {
  String? selectedCustomerId;
  List<Debt>? selectedCustomerDebts;
  String? selectedCustomerName;
  String? selectedCustomerPhone;

  @override
  Widget build(BuildContext context) {
    final debtsAsync = ref.watch(debtsGroupedProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile =
        ResponsiveBreakpoints.isMobile(screenWidth) ||
        ResponsiveBreakpoints.isTablet(screenWidth);

    final title = _lang(context, 'الديون', 'Debts');
    return GradientScaffold(
      appBar: AppTopBar(title: title),
      body: debtsAsync.when(
        data: (grouped) {
          if (grouped.isEmpty) {
            return Center(child: Text(_lang(context, 'لا توجد ديون', 'No debts')));
          }

          if (isMobile) {
            return _buildMobileLayout(context, grouped);
          }

          return _buildDesktopLayout(context, grouped);
        },
        error: (error, stackTrace) => AppErrorState(
          message: _lang(context, 'فشل تحميل الديون', 'Failed to load debts'),
          details: error.toString(),
          stackTrace: stackTrace,
          onRetry: () => ref.invalidate(debtsGroupedProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    Map<String?, List<Debt>> grouped,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tableWidth = ResponsiveBreakpoints.isLargeDesktop(screenWidth)
        ? screenWidth * 0.65
        : screenWidth * 0.6;

    return Row(
      children: [
        // Left: Debts Table (60-65%)
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: tableWidth),
              child: DataTable(
                columns: [
                  DataColumn(label: Text(_lang(context, 'اسم العميل', 'Customer Name'))),
                  DataColumn(label: Text(_lang(context, 'الهاتف', 'Phone'))),
                  DataColumn(label: Text(_lang(context, 'المبلغ المستحق', 'Total Due'))),
                  DataColumn(label: Text(_lang(context, 'عدد الديون', '# Debts'))),
                  DataColumn(label: Text(_lang(context, 'التاريخ', 'Date'))),
                ],
                rows: grouped.entries.map((entry) {
                  final customerId = entry.key;
                  final debts = entry.value;

                  if (debts.isEmpty) {
                    return const DataRow(cells: []);
                  }

                  final first = debts.first;
                  final customerName = first.customerName;
                  final customerPhone = first.customerPhone;

                  final totalDue = debts.fold<int>(
                    0,
                    (sum, debt) => sum + debt.amount,
                  );

                  final earliestDate = debts
                      .map((d) => d.createdAt)
                      .reduce((a, b) => a.isBefore(b) ? a : b);

                  return DataRow(
                    selected: selectedCustomerId == customerId,
                    onSelectChanged: (_) {
                      setState(() {
                        selectedCustomerId = customerId;
                        selectedCustomerDebts = debts;
                        selectedCustomerName = customerName;
                        selectedCustomerPhone = customerPhone;
                      });
                    },
                    cells: [
                      DataCell(Text(customerName)),
                      DataCell(Text(customerPhone ?? '-')),
                      DataCell(
                        Text(
                          formatMoneyCents(totalDue),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      DataCell(Text(debts.length.toString())),
                      DataCell(
                        Text(
                          DateFormat('yyyy-MM-dd').format(earliestDate),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        // Right: Details Panel (40%)
        if (selectedCustomerId != null && selectedCustomerDebts != null)
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(left: BorderSide(color: Colors.grey.shade300)),
              ),
              child: _buildDetailsPanel(
                context: context,
                customerId: selectedCustomerId,
                debts: selectedCustomerDebts!,
                customerName: selectedCustomerName ?? 'Unknown',
                customerPhone: selectedCustomerPhone,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    Map<String?, List<Debt>> grouped,
  ) {
    return ListView(
      children: grouped.entries.map((entry) {
        final customerId = entry.key;
        final debts = entry.value;

        if (debts.isEmpty) {
          return const SizedBox.shrink();
        }

        final first = debts.first;
        final customerName = first.customerName;
        final customerPhone = first.customerPhone;

        final totalDue = debts.fold<int>(0, (sum, debt) => sum + debt.amount);

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCustomerId = customerId;
              selectedCustomerDebts = debts;
              selectedCustomerName = customerName;
              selectedCustomerPhone = customerPhone;
            });
            _showMobileDetailsBottomSheet(
              context: context,
              customerId: customerId,
              debts: debts,
              customerName: customerName,
              customerPhone: customerPhone,
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (customerPhone != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Phone: $customerPhone',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Due: ${formatMoneyCents(totalDue)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        '${debts.length} debts',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showMobileDetailsBottomSheet({
    required BuildContext context,
    String? customerId,
    required List<Debt> debts,
    required String customerName,
    String? customerPhone,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: _buildDetailsPanel(
            context: bottomSheetContext,
            customerId: customerId,
            debts: debts,
            customerName: customerName,
            customerPhone: customerPhone,
          ),
        );
      },
    );
  }

  Widget _buildDetailsPanel({
    required BuildContext context,
    String? customerId,
    required List<Debt> debts,
    required String customerName,
    String? customerPhone,
  }) {
    final totalDue = debts.fold<int>(0, (sum, d) => sum + d.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Customer Details',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.blue600.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name: $customerName',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (customerPhone != null)
                      Text(
                        'Phone: $customerPhone',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Due: ${formatMoneyCents(totalDue)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Number of Debts: ${debts.length}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Debts List
          Text(
            'Debts List',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...debts.map((debt) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          debt.sourceType.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        formatMoneyCents(debt.amount),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(debt.createdAt)}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      if (debt.dueDate != null)
                        Text(
                          'Due: ${DateFormat('yyyy-MM-dd').format(debt.dueDate!)}',
                          style: const TextStyle(fontSize: 11),
                        ),
                    ],
                  ),
                  if (debt.note != null && debt.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Note: ${debt.note}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          // Payments History
          Text(
            'Payment History',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          customerId != null
              ? ref
                    .watch(recentPaymentsProvider(customerId))
                    .when(
                      data: (payments) {
                        // Filter payments: show only those after the oldest current debt
                        final oldestDebtDate = debts.isNotEmpty
                            ? debts
                                  .map((d) => d.createdAt)
                                  .reduce((a, b) => a.isBefore(b) ? a : b)
                            : DateTime.now();

                        final relevantPayments = payments
                            .where((p) => p.createdAt.isAfter(oldestDebtDate))
                            .toList();

                        if (relevantPayments.isEmpty) {
                          return Text(
                            'No payments for current debts',
                            style: TextStyle(color: Colors.grey.shade500),
                          );
                        }

                        return Column(
                          children: relevantPayments.map((payment) {
                            final paymentDate = DateFormat(
                              'yyyy-MM-dd HH:mm:ss',
                            ).format(payment.createdAt);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Amount: ${formatMoneyCents(payment.amount)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Date: $paymentDate',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const SizedBox(
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (error, st) => Text(
                        'Error loading payments: $error',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
              : Text(
                  'No payments recorded',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
          const SizedBox(height: 16),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showReceivePaymentDialog(
                    context,
                    customerId,
                    customerName,
                    customerPhone,
                  ),
                  icon: const Icon(Icons.payment),
                  label: const Text('Receive Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReceivePaymentDialog(
    BuildContext context,
    String? customerId,
    String customerName,
    String? customerPhone,
  ) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            bool isProcessing = false;
            return AlertDialog(
              title: const Text('Receive Payment'),
              content: SizedBox(
                width: MediaQuery.of(dialogContext).size.width < 520
                    ? MediaQuery.of(dialogContext).size.width * 0.9
                    : 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Payment Amount (₪)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: noteController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Note',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    amountController.dispose();
                    noteController.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isProcessing
                      ? null // ignore: dead_code
                      : () async {
                          final amount = _parseShekelsToCents(
                            amountController.text,
                          );
                          if (amount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Payment amount must be positive',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            isProcessing = true;
                          });

                          try {
                            final db = ref.read(dbProvider);
                            final paymentNote =
                                noteController.text.trim().isEmpty
                                ? null
                                : noteController.text.trim();

                            // Get total debts BEFORE payment
                            final debtsBeforePayment = customerId != null
                                ? await (db.select(db.debts)
                                        ..where(
                                          (tbl) =>
                                              tbl.customerId.equals(customerId),
                                        )
                                        ..where(
                                          (tbl) => tbl.isSettled.equals(false),
                                        ))
                                      .get()
                                : await (db.select(db.debts)
                                        ..where(
                                          (tbl) => tbl.customerId.isNull(),
                                        )
                                        ..where(
                                          (tbl) => tbl.isSettled.equals(false),
                                        ))
                                      .get();

                            final totalDebtsBefore = debtsBeforePayment
                                .fold<int>(0, (sum, debt) => sum + debt.amount);

                            final excessPayment = await db
                                .receivePaymentApplyToDebts(
                                  customerId: customerId,
                                  paymentAmount: amount,
                                  note: paymentNote,
                                );

                            // Calculate remaining debts
                            final remainingDebts =
                                totalDebtsBefore - amount + excessPayment;

                            // Invalidate and refresh the debts list
                            ref.invalidate(debtsGroupedProvider);
                            if (customerId != null) {
                              ref.invalidate(
                                recentPaymentsProvider(customerId),
                              );
                            }

                            if (!context.mounted) {
                              amountController.dispose();
                              noteController.dispose();
                              return;
                            }

                            amountController.dispose();
                            noteController.dispose();
                            Navigator.pop(context);

                            // Reset selected customer to force refresh
                            setState(() {
                              selectedCustomerId = null;
                              selectedCustomerDebts = null;
                              selectedCustomerName = null;
                              selectedCustomerPhone = null;
                            });

                            // Show print preview
                            _showPaymentReceiptPreview(
                              context: context,
                              customerName: customerName,
                              customerPhone: customerPhone,
                              paymentAmount: amount,
                              remainingBalance: remainingDebts,
                              note: paymentNote,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: remainingDebts > 0
                                    ? Text(
                                        'Payment received. Remaining: ${formatMoneyCents(remainingDebts)}',
                                      )
                                    : const Text(
                                        'Payment received. All debts cleared!',
                                      ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                ),
                              );
                            }
                            setDialogState(() {
                              isProcessing = false;
                            });
                          }
                        },
                  child: isProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Process Payment'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Ensure disposal even if dialog is dismissed
      try {
        amountController.dispose();
      } catch (e) {
        // Already disposed
      }
      try {
        noteController.dispose();
      } catch (e) {
        // Already disposed
      }
    });
  }

  void _showPaymentReceiptPreview({
    required BuildContext context,
    required String customerName,
    String? customerPhone,
    required int paymentAmount,
    required int remainingBalance,
    String? note,
  }) {
    final printService = PrintService(ref.read(dbProvider));

    showDialog(
      context: context,
      builder: (dialogContext) => ResponsiveDialog(
        child: PdfPreview(
          build: (format) => printService.buildPaymentReceiptPdf(
            customerName: customerName,
            customerPhone: customerPhone,
            paymentAmount: paymentAmount,
            remainingBalance: remainingBalance,
            note: note,
          ),
        ),
      ),
    );
  }

  int _parseShekelsToCents(String value) {
    final valueStr = value.trim();
    if (valueStr.isEmpty) return 0;
    final normalized = valueStr.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return 0;
    return (parsed * 100).round();
  }
}
