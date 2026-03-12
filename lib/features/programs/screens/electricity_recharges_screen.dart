import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos_store/design/app_colors.dart';
import 'package:pos_store/design/app_spacing.dart';
import 'package:pos_store/providers/programs_provider.dart';

class ElectricityRechargesScreen extends ConsumerStatefulWidget {
  const ElectricityRechargesScreen({super.key});

  @override
  ConsumerState<ElectricityRechargesScreen> createState() =>
      _ElectricityRechargesScreenState();
}

class _ElectricityRechargesScreenState
    extends ConsumerState<ElectricityRechargesScreen> {
  DateTime? selectedDate;
  String filter = 'All'; // All, Electricity, MadaBill

  @override
  Widget build(BuildContext context) {
    final recharges = ref.watch(electricityRechargesProvider);
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm');
    final currencyFormatter = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      appBar: AppBar(title: const Text('كهرباء وفواتير مادة'), elevation: 0),
      body: Column(
        children: [
          // Filters
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
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(label: Text('الكل'), value: 'All'),
                          ButtonSegment(
                            label: Text('كهرباء'),
                            value: 'Electricity',
                          ),
                          ButtonSegment(label: Text('مادة'), value: 'MadaBill'),
                        ],
                        selected: {filter},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() => filter = newSelection.first);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: recharges.when(
              data: (data) {
                // Apply filters
                var filtered = data;
                if (selectedDate != null) {
                  filtered = filtered.where((r) {
                    final same =
                        r.operatedAt.year == selectedDate!.year &&
                        r.operatedAt.month == selectedDate!.month &&
                        r.operatedAt.day == selectedDate!.day;
                    return same;
                  }).toList();
                }
                if (filter != 'All') {
                  filtered = filtered
                      .where((r) => r.operationType == filter)
                      .toList();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد عمليات',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                final total = filtered.fold<int>(0, (sum, r) => sum + r.amount);

                return ListView(
                  children: [
                    ...filtered.map(
                      (r) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: ListTile(
                          title: Text(r.customerName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${r.operationType}${r.subscriptionNumber != null ? ' - ${r.subscriptionNumber}' : ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                dateFormatter.format(r.operatedAt),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              if (r.notes != null)
                                Text(
                                  r.notes!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                          trailing: Text(
                            '${currencyFormatter.format(r.amount / 100)} ﷼',
                            style: Theme.of(context).textTheme.titleMedium,
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
    final subscriptionController = TextEditingController();
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    String selectedType = 'Electricity';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة عملية شحن'),
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
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                items: const [
                  DropdownMenuItem(value: 'Electricity', child: Text('كهرباء')),
                  DropdownMenuItem(
                    value: 'MadaBill',
                    child: Text('فاتورة مادة'),
                  ),
                ],
                onChanged: (v) => selectedType = v!,
                decoration: const InputDecoration(
                  labelText: 'نوع الفاتورة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: subscriptionController,
                decoration: const InputDecoration(
                  labelText: 'رقم الاشتراك (اختياري)',
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
              subscriptionController.dispose();
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
                addElectricityRechargeProvider((
                  customerName: nameController.text,
                  subscriptionNumber: subscriptionController.text.isEmpty
                      ? null
                      : subscriptionController.text,
                  amount: amount,
                  type: selectedType,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                )).future,
              );
              nameController.dispose();
              subscriptionController.dispose();
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
