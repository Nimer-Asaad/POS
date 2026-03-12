import 'package:flutter/material.dart';
import 'package:pos_store/core/formatting/money.dart';
import 'package:pos_store/design/app_spacing.dart';
import 'package:pos_store/features/pos/data/models/telelink_model.dart';
import 'dart:ui' as ui;

class TelelinkForm extends StatefulWidget {
  final void Function({
    required String category,
    required String provider,
    required String providerLabel,
    required int amountCents,
    required int profitCents,
    String? notes,
  })?
  onAddService;

  const TelelinkForm({super.key, this.onAddService});

  @override
  State<TelelinkForm> createState() => _TelelinkFormState();
}

class _TelelinkFormState extends State<TelelinkForm> {
  TelinkServiceCategory _selectedCategory = TelinkServiceCategory.bills;
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double _parseInputToIls(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0.0;
    final normalized = trimmed.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  TelinkProfitResult? _calculateProfit() {
    final amount = _parseInputToIls(_amountController.text);

    if (amount <= 0) return null;

    final amountCents = (amount * 100).round();

    return calculateTelinkProfit(
      amountCents: amountCents,
      category: _selectedCategory,
    );
  }

  void _onSubmit() {
    final amount = _parseInputToIls(_amountController.text);
    if (amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    final profitResult = _calculateProfit();
    if (profitResult == null) {
      _showError('Invalid amount');
      return;
    }

    // Show warning if low profit
    if (profitResult.isLowProfit) {
      final message = profitResult.getWarningMessage(true);
      _showWarning(message);
    }

    // Here you would store the transaction
    print('Telelink Transaction:');
    print('  Provider: Telelink');
    print('  Category: ${_selectedCategory.labelAr}');
    print('  Amount: ${formatMoneyCents((amount * 100).round())}');
    print('  Profit %: ${_selectedCategory.profitPercent}%');
    print('  Profit: ${formatMoneyCents(profitResult.finalProfitCents)}');
    print('  Profit %: ${profitResult.profitPercentShown.toStringAsFixed(2)}%');

    if (widget.onAddService != null) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      widget.onAddService!(
        category: 'websites',
        provider: 'telelink',
        providerLabel:
            '${isArabic ? 'تيليلينك' : 'Telelink'} - ${isArabic ? _selectedCategory.labelAr : _selectedCategory.labelEn}',
        amountCents: (amount * 100).round(),
        profitCents: profitResult.finalProfitCents,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
    }

    // Clear form
    _amountController.clear();
    _notesController.clear();

    _showSuccess('Service added to cart');
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showWarning(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? 'نموذج التيليلينك' : 'Telelink Form',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isArabic ? 'تيليلينك' : 'Telelink',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Service Category Segmented Button
            Text(
              isArabic ? 'نوع الخدمة' : 'Service Type',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SegmentedButton<TelinkServiceCategory>(
              segments: [
                ButtonSegment(
                  value: TelinkServiceCategory.bills,
                  label: Text(isArabic ? 'فواتير' : 'Bills'),
                ),
                ButtonSegment(
                  value: TelinkServiceCategory.balance,
                  label: Text(isArabic ? 'رصيد' : 'Balance'),
                ),
                ButtonSegment(
                  value: TelinkServiceCategory.bundles,
                  label: Text(isArabic ? 'حزم' : 'Bundles'),
                ),
                ButtonSegment(
                  value: TelinkServiceCategory.roaming,
                  label: Text(isArabic ? 'تجوال' : 'Roaming'),
                ),
                ButtonSegment(
                  value: TelinkServiceCategory.games,
                  label: Text(isArabic ? 'ألعاب' : 'Games'),
                ),
              ],
              selected: {_selectedCategory},
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedCategory = selected.first;
                });
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Add games badge if category is games
            if (_selectedCategory == TelinkServiceCategory.games) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.9),
                      Colors.deepPurple.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎮', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      isArabic ? '+1₪ مكافأة' : '+1₪ Bonus',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],



            // Amount Input
            Text(
              isArabic ? 'المبلغ (₪)' : 'Amount (₪)',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: '0.00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Notes Field
            Text(
              isArabic ? 'ملاحظات (اختيارية)' : 'Notes (Optional)',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: isArabic ? 'أضف ملاحظة' : 'Add a note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Live Profit Preview
            _buildProfitPreview(context, isArabic),

            const SizedBox(height: AppSpacing.md),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _parseInputToIls(_amountController.text) > 0
                    ? _onSubmit
                    : null,
                icon: const Icon(Icons.shopping_cart),
                label: Text(isArabic ? 'إضافة للسلة' : 'Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitPreview(BuildContext context, bool isArabic) {
    final profitResult = _calculateProfit();

    if (profitResult == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!profitResult.isLowProfit)
            BoxShadow(
              color: Colors.green.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          if (profitResult.isLowProfit)
            BoxShadow(
              color: Colors.orange.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 0,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.grey[900]!.withOpacity(0.4),
              border: Border.all(
                color: profitResult.isLowProfit
                    ? Colors.orange.withOpacity(0.5)
                    : Colors.green.withOpacity(0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'معاينة الربح' : 'Profit Preview',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                _buildProfitRow(
                  context,
                  isArabic ? 'الربح المتوقع' : 'Expected Profit',
                  formatMoneyCents(profitResult.finalProfitCents),
                  profitResult.isLowProfit ? Colors.orange : Colors.green,
                  isArabic,
                  isBold: true,
                ),
                const SizedBox(height: 6),
                _buildProfitRow(
                  context,
                  isArabic ? 'نسبة الربح' : 'Profit %',
                  '${profitResult.profitPercentShown.toStringAsFixed(2)}%',
                  Colors.cyan,
                  isArabic,
                  isBold: true,
                ),
                const SizedBox(height: 6),
                _buildProfitRow(
                  context,
                  isArabic ? 'التكلفة التقديرية' : 'Estimated Cost',
                  formatMoneyCents(profitResult.estimatedCostCents),
                  Colors.grey,
                  isArabic,
                ),
                if (profitResult.hasGameBonus) ...[  
                  const SizedBox(height: 6),
                  _buildProfitRow(
                    context,
                    isArabic ? '🎮 مكافأة ألعاب' : '🎮 Games Bonus',
                    '+1₪',
                    Colors.purple,
                    isArabic,
                  ),
                ],
                if (profitResult.isLowProfit) ...[
                  const SizedBox(height: 10),
                  Text(
                    profitResult.getWarningMessage(isArabic),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfitRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
    bool isArabic, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey[400],
            letterSpacing: 0.2,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: isBold ? FontWeight.bold : null,
            color: valueColor,
            fontSize: isBold ? 12 : 11,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
