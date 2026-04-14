import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/side_revenue_category.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/ui/widgets/app_card.dart';
import '../../../../core/ui/widgets/gradient_button.dart';
import '../../../../design/app_colors.dart';
import '../../../../design/app_spacing.dart';
import '../../../../design/app_radius.dart';
import '../../../../providers/programs_provider.dart';

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

class SideRevenueForm extends ConsumerStatefulWidget {
  final void Function({
    required String category,
    required String description,
    required int amountCents,
    String? customerName,
    String? notes,
  })? onAddSideRevenue;

  const SideRevenueForm({super.key, this.onAddSideRevenue});

  @override
  ConsumerState<SideRevenueForm> createState() => _SideRevenueFormState();
}

class _SideRevenueFormState extends ConsumerState<SideRevenueForm> {
  SideRevenueCategory _selectedCategory = SideRevenueCategory.icloud;
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _customerNameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final description = _descriptionController.text.trim();
    final amount = (_parseMoneyToIls(_amountController.text) * 100).round();
    final customerName = _customerNameController.text.trim();
    final notes = _notesController.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(context, 'يجب إدخال وصف الخدمة', 'Must enter service description'),
          ),
        ),
      );
      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(context, 'يجب إدخال مبلغ صحيح', 'Must enter valid amount'),
          ),
        ),
      );
      return;
    }

    try {
      setState(() => _isSubmitting = true);

      final dao = ref.read(sideRevenueDaoProvider);
      await dao.addSideRevenue(
        category: _selectedCategory.value,
        description: description,
        amountCents: amount,
        customerName: customerName.isEmpty ? null : customerName,
        notes: notes.isEmpty ? null : notes,
      );

      widget.onAddSideRevenue?.call(
        category: _selectedCategory.value,
        description: description,
        amountCents: amount,
        customerName: customerName.isEmpty ? null : customerName,
        notes: notes.isEmpty ? null : notes,
      );

      // Clear form
      _descriptionController.clear();
      _amountController.clear();
      _notesController.clear();
      _customerNameController.clear();
      setState(() => _selectedCategory = SideRevenueCategory.icloud);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(context, 'تم إضافة الربح الجانبي بنجاح', 'Side revenue added successfully'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(context, 'خطأ: $e', 'Error: $e'),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _lang(context, 'إضافة ربح جانبي', 'Add Side Revenue'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            // Category Dropdown
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: DropdownButton<SideRevenueCategory>(
                value: _selectedCategory,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                items: SideRevenueCategory.allCategories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.getLabel(isArabic)),
                        ))
                    .toList(),
                onChanged: (category) {
                  if (category != null) {
                    setState(() => _selectedCategory = category);
                  }
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Description Field
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: _lang(context, 'وصف الخدمة', 'Service description'),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Amount Field
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: _lang(context, 'المبلغ', 'Amount'),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: 'ر.س',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Customer Name Field (Optional)
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: TextField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  hintText: _lang(context, 'اسم العميل (اختياري)', 'Customer name (optional)'),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Notes Field (Optional)
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: _lang(context, 'ملاحظات (اختياري)', 'Notes (optional)'),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.note),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Submit Button
            GradientButton(
              onPressed: _isSubmitting ? null : _submit,
              label: _lang(context, 'إضافة الربح', 'Add Profit'),
            ),
          ],
        ),
      ),
    );
  }

  double _parseMoneyToIls(String value) {
    if (value.isEmpty) return 0;
    return double.tryParse(value.replaceAll(',', '.')) ?? 0;
  }
}
