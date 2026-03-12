import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos_store/design/app_spacing.dart';
import 'package:pos_store/providers/programs_provider.dart';

class FarahnetPaymentsScreen extends ConsumerStatefulWidget {
  const FarahnetPaymentsScreen({super.key});

  @override
  ConsumerState<FarahnetPaymentsScreen> createState() =>
      _FarahnetPaymentsScreenState();
}

class _FarahnetPaymentsScreenState
    extends ConsumerState<FarahnetPaymentsScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(farahnetPaymentsProvider);
    final dailyTotals = selectedDate != null
        ? ref.watch(farahnetPaymentsDailyTotalsProvider(selectedDate!))
        : null;
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm');
    final currencyFormatter = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      appBar: AppBar(title: const Text('فاراه نت'), elevation: 0),
      body: Column(
        children: [
          // Date Filter
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => selectedDate = date);
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : 'اختر التاريخ',
                        ),
                      ),
                    ),
                    if (selectedDate != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => selectedDate = null),
                      ),
                    ],
                  ],
                ),
                if (selectedDate != null && dailyTotals != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  dailyTotals.when(
                    data: (totals) {
                      return Card(
                        color: Colors.orange.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'إجمالي المبلغ:',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '${currencyFormatter.format(((totals['totalAmount'] ?? 0)) / 100)} ﷼',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الربح (2%):',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.green),
                                  ),
                                  Text(
                                    '+ ${currencyFormatter.format(((totals['totalProfit'] ?? 0)) / 100)} ﷼',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                  ),
                                ],
                              ),
                              const Divider(height: AppSpacing.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'المبلغ المستحق:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                  ),
                                  Text(
                                    '${currencyFormatter.format(((totals['totalAmount'] ?? 0)) / 100)} ﷼',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
          // List
          Expanded(
            child: payments.when(
              data: (data) {
                var filtered = data;
                if (selectedDate != null) {
                  filtered = filtered.where((p) {
                    final same =
                        p.operatedAt.year == selectedDate!.year &&
                        p.operatedAt.month == selectedDate!.month &&
                        p.operatedAt.day == selectedDate!.day;
                    return same;
                  }).toList();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد عمليات',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return ListView(
                  children: [
                    ...filtered.map(
                      (p) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    p.customerName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  Text(
                                    dateFormatter.format(p.operatedAt),
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'المبلغ:',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    '${currencyFormatter.format(p.amountPaid / 100)} ﷼',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الربح:',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.green),
                                  ),
                                  Text(
                                    '+ ${currencyFormatter.format(p.profitAmount / 100)} ﷼',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                  ),
                                ],
                              ),
                              if (p.notes != null) ...[
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  p.notes!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('خطأ: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة عملية فاراه نت'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم العميل',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  suffixText: '﷼',
                  border: OutlineInputBorder(),
                  helperText: 'سيتم حساب 2% ربح تلقائياً',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات (اختيارية)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.dispose();
              amountController.dispose();
              notesController.dispose();
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = int.parse(
                (double.parse(amountController.text) * 100).toString(),
              );
              await ref.read(
                addFarahnetPaymentProvider((
                  customerName: nameController.text,
                  amountPaid: amount,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                )).future,
              );
              nameController.dispose();
              amountController.dispose();
              notesController.dispose();
              if (mounted) Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
