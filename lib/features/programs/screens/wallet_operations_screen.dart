import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos_store/design/app_colors.dart';
import 'package:pos_store/design/app_spacing.dart';
import 'package:pos_store/providers/programs_provider.dart';

class WalletOperationsScreen extends ConsumerStatefulWidget {
  const WalletOperationsScreen({super.key});

  @override
  ConsumerState<WalletOperationsScreen> createState() =>
      _WalletOperationsScreenState();
}

class _WalletOperationsScreenState
    extends ConsumerState<WalletOperationsScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final operations = ref.watch(walletOperationsProvider);
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm');
    final currencyFormatter = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      appBar: AppBar(title: const Text('محفظة العميل'), elevation: 0),
      body: Column(
        children: [
          // Date Filter
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
          ),
          // List
          Expanded(
            child: operations.when(
              data: (data) {
                var filtered = data;
                if (selectedDate != null) {
                  filtered = filtered.where((o) {
                    final same =
                        o.operatedAt.year == selectedDate!.year &&
                        o.operatedAt.month == selectedDate!.month &&
                        o.operatedAt.day == selectedDate!.day;
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

                final total = filtered.fold<int>(0, (sum, o) => sum + o.amount);

                return ListView(
                  children: [
                    ...filtered.map(
                      (o) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: ListTile(
                          title: Text(o.customerName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateFormatter.format(o.operatedAt),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              if (o.notes != null)
                                Text(
                                  o.notes!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                          trailing: Text(
                            '+ ${currencyFormatter.format(o.amount / 100)} ﷼',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Card(
                        color: AppColors.blue600.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'المجموع:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${currencyFormatter.format(total / 100)} ﷼',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blue600,
                                    ),
                              ),
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
        title: const Text('إضافة عملية محفظة'),
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
                addWalletOperationProvider((
                  customerName: nameController.text,
                  amount: amount,
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
