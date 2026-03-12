import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos_store/design/app_spacing.dart';
import 'package:pos_store/providers/programs_provider.dart';

class TelelinkOperationsScreen extends ConsumerStatefulWidget {
  const TelelinkOperationsScreen({super.key});

  @override
  ConsumerState<TelelinkOperationsScreen> createState() =>
      _TelelinkOperationsScreenState();
}

class _TelelinkOperationsScreenState
    extends ConsumerState<TelelinkOperationsScreen> {
  DateTime? selectedDate;
  String selectedType = 'الكل'; // الكل, فواتير, العاب, رصيد

  String _getOperationType(String? notes) {
    if (notes == null || notes.isEmpty) return 'فواتير';
    if (notes.contains('|')) {
      return notes.split('|')[0];
    }
    return notes; // if no separator, the whole notes is the type
  }

  String _getNoteContent(String? notes) {
    if (notes == null || notes.isEmpty) return '';
    if (notes.contains('|')) {
      return notes.split('|')[1];
    }
    return ''; // if no separator, no additional notes
  }

  @override
  Widget build(BuildContext context) {
    final operations = ref.watch(telelinkOperationsProvider);
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm');
    final currencyFormatter = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      appBar: AppBar(title: const Text('تيليلينك'), elevation: 0),
      body: Column(
        children: [
          // Date Filter + Type Filter
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
                // Type Filter Buttons
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.start,
                  children: ['الكل', 'فواتير', 'العاب', 'رصيد']
                      .map(
                        (type) => FilterChip(
                          label: Text(type),
                          selected: selectedType == type,
                          onSelected: (selected) {
                            setState(
                              () => selectedType = selected ? type : 'الكل',
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: operations.when(
              data: (data) {
                var filtered = data;

                // Filter by date
                if (selectedDate != null) {
                  filtered = filtered.where((o) {
                    final same =
                        o.operatedAt.year == selectedDate!.year &&
                        o.operatedAt.month == selectedDate!.month &&
                        o.operatedAt.day == selectedDate!.day;
                    return same;
                  }).toList();
                }

                // Filter by type
                if (selectedType != 'الكل') {
                  filtered = filtered.where((o) {
                    final opType = _getOperationType(o.notes);
                    return opType == selectedType;
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
                    ...filtered.map((o) {
                      final opType = _getOperationType(o.notes);
                      final noteContent = _getNoteContent(o.notes);
                      return Card(
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
                                '$opType • ${dateFormatter.format(o.operatedAt)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              if (noteContent.isNotEmpty)
                                Text(
                                  noteContent,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                          trailing: Text(
                            '+ ${currencyFormatter.format(o.amount / 100)} ﷼',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.blue),
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Card(
                        color: Colors.blue.withOpacity(0.1),
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
                                      color: Colors.blue,
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
    String selectedDialogType = 'فواتير';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('إضافة عملية تيليلينك'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedDialogType,
                  decoration: const InputDecoration(
                    labelText: 'النوع',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'فواتير', child: Text('فواتير')),
                    DropdownMenuItem(value: 'العاب', child: Text('العاب')),
                    DropdownMenuItem(value: 'رصيد', child: Text('رصيد')),
                  ],
                  onChanged: (value) {
                    setState(() => selectedDialogType = value ?? 'فواتير');
                  },
                ),
                const SizedBox(height: AppSpacing.md),
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
                  addTelelinkOperationProvider((
                    customerName: nameController.text,
                    amount: amount,
                    operationType: selectedDialogType,
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
      ),
    );
  }
}
