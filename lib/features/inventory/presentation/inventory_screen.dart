import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/formatting/money.dart';
import '../../../core/constants/responsive_breakpoints.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_button.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/utils/image_storage.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../design/app_colors.dart';
import '../../../providers/db_provider.dart';
import 'package:pos_store/l10n/app_localizations.dart';
import '../providers/products_providers.dart';
import '../domain/models/product_model.dart';

final inventorySearchQueryProvider = StateProvider<String>((ref) => '');

// Sorting provider: 'name_asc', 'name_desc', 'price_asc', 'price_desc', 'category_asc', 'category_desc', 'none'
final sortingTypeProvider = StateProvider<String>((ref) => 'none');

// Category filter provider: empty string means no filter
final categoryFilterProvider = StateProvider<String>((ref) => '');

// Price range filter provider
final priceRangeProvider = StateProvider<({int min, int max})>((ref) => (
  min: 0,
  max: 999999999,
));

// Products stream provider with enhanced smart search filter and sorting
final filteredProductsStreamProvider =
    StreamProvider.autoDispose<List<ProductModel>>((ref) {
      final repository = ref.watch(productsRepositoryProvider);
      final searchQuery = ref.watch(inventorySearchQueryProvider);
      final sortingType = ref.watch(sortingTypeProvider);
      final categoryFilter = ref.watch(categoryFilterProvider);
      final priceRange = ref.watch(priceRangeProvider);

      return repository.watchAll().map((products) {
        // Step 1: Apply search filter
        final query = searchQuery.toLowerCase().trim();
        var filtered = products.where((p) {
          if (query.isEmpty) return true;
          
          // Search in name
          if (p.name.toLowerCase().contains(query)) return true;
          
          // Search in barcode
          if (p.barcode?.toLowerCase().contains(query) ?? false) return true;
          
          // Search in category
          if (p.category.toLowerCase().contains(query)) return true;
          
          // Search in sell price (formatted)
          final sellPriceFormatted = formatMoneyCents(p.sellPrice).toLowerCase();
          if (sellPriceFormatted.contains(query)) return true;
          
          // Search in sell price (raw number)
          final sellPriceRaw = (p.sellPrice / 100).toString();
          if (sellPriceRaw.contains(query)) return true;
          
          // Search in cost price (formatted)
          final costPriceFormatted = formatMoneyCents(p.costPrice).toLowerCase();
          if (costPriceFormatted.contains(query)) return true;
          
          // Search in cost price (raw number)
          final costPriceRaw = (p.costPrice / 100).toString();
          if (costPriceRaw.contains(query)) return true;
          
          // Search in quantity
          if (p.qty.toString().contains(query)) return true;
          
          return false;
        }).toList();

        // Step 2: Apply category filter
        if (categoryFilter.isNotEmpty) {
          filtered = filtered
              .where((p) => p.category.toLowerCase() == categoryFilter.toLowerCase())
              .toList();
        }

        // Step 3: Apply price range filter
        filtered = filtered
            .where((p) => p.sellPrice >= priceRange.min && p.sellPrice <= priceRange.max)
            .toList();

        // Step 4: Apply sorting
        switch (sortingType) {
          case 'name_asc':
            filtered.sort((a, b) => a.name.compareTo(b.name));
            break;
          case 'name_desc':
            filtered.sort((a, b) => b.name.compareTo(a.name));
            break;
          case 'price_asc':
            filtered.sort((a, b) => a.sellPrice.compareTo(b.sellPrice));
            break;
          case 'price_desc':
            filtered.sort((a, b) => b.sellPrice.compareTo(a.sellPrice));
            break;
          case 'category_asc':
            filtered.sort((a, b) => a.category.compareTo(b.category));
            break;
          case 'category_desc':
            filtered.sort((a, b) => b.category.compareTo(a.category));
            break;
          default:
            // Keep original order
            break;
        }

        return filtered;
      });
    });


class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isCostVisible = false;

  // Predefined categories
  final List<Map<String, String>> _predefinedCategories = [
    {'ar': 'اكسيسوارات', 'en': 'Accessories'},
    {'ar': 'أجهزه محموله', 'en': 'Mobile Devices'},
    {'ar': 'لزقات ماكنه', 'en': 'Machine Stickers'},
    {'ar': 'قطع صيانه', 'en': 'Spare Parts'},
  ];

  String _t(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  List<String> _getCategoryOptions(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return _predefinedCategories
        .map((cat) => isArabic ? cat['ar']! : cat['en']!)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _parseInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    return int.tryParse(trimmed) ?? 0;
  }

  int _parseMoneyToIlsCents(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    final normalized = trimmed.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) return 0;
    return (parsed * 100).round();
  }

  String _centsToInput(int cents) {
    if (cents % 100 == 0) {
      return (cents ~/ 100).toString();
    }
    return (cents / 100).toStringAsFixed(2);
  }

  ({
    int categoryCount,
    int productCount,
    int totalSellValueCents,
    int totalCostValueCents,
  }) _calculateInventoryStats(List<ProductModel> products) {
    final inStockProducts = products.where((p) => p.qty > 0);
    final categories = <String>{};
    var productCount = 0;
    var totalSellValueCents = 0;
    var totalCostValueCents = 0;

    for (final product in inStockProducts) {
      categories.add(product.category.trim().toLowerCase());
      productCount += 1;
      totalSellValueCents += product.sellPrice * product.qty;
      totalCostValueCents += product.costPrice * product.qty;
    }

    return (
      categoryCount: categories.length,
      productCount: productCount,
      totalSellValueCents: totalSellValueCents,
      totalCostValueCents: totalCostValueCents,
    );
  }

  Widget _buildSummaryTile({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    final tileColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: tileColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: tileColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    final currentSorting = ref.read(sortingTypeProvider);
    final currentCategory = ref.read(categoryFilterProvider);
    final currentPriceRange = ref.read(priceRangeProvider);
    
    final minPriceController = TextEditingController(
      text: _centsToInput(currentPriceRange.min),
    );
    final maxPriceController = TextEditingController(
      text: _centsToInput(currentPriceRange.max),
    );

    String selectedSorting = currentSorting;
    String selectedCategory = currentCategory;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_t(context, 'الفلاتر والترتيب', 'Filters & Sorting')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sorting section
                    Text(
                      _t(context, 'ترتيب حسب الاسم', 'Sort by Name'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedSorting == 'name_asc'
                                    ? AppColors.blue600
                                    : Colors.grey[300],
                          ),
                          onPressed: () {
                            setDialogState(() => selectedSorting = 'name_asc');
                          },
                          child: const Text('A → Z'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedSorting == 'name_desc'
                                    ? AppColors.blue600
                                    : Colors.grey[300],
                          ),
                          onPressed: () {
                            setDialogState(() => selectedSorting = 'name_desc');
                          },
                          child: const Text('Z → A'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedSorting == 'none'
                                    ? AppColors.blue600
                                    : Colors.grey[300],
                          ),
                          onPressed: () {
                            setDialogState(() => selectedSorting = 'none');
                          },
                          child: Text(_t(context, 'بدون', 'None')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Price sorting section
                    Text(
                      _t(context, 'ترتيب حسب السعر', 'Sort by Price'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedSorting == 'price_asc'
                                    ? AppColors.blue600
                                    : Colors.grey[300],
                          ),
                          onPressed: () {
                            setDialogState(() => selectedSorting = 'price_asc');
                          },
                          child: const Text('↑ Low'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedSorting == 'price_desc'
                                    ? AppColors.blue600
                                    : Colors.grey[300],
                          ),
                          onPressed: () {
                            setDialogState(() => selectedSorting = 'price_desc');
                          },
                          child: const Text('↓ High'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Category sorting section
                    Text(
                      _t(context, 'ترتيب حسب التصنيف', 'Sort by Category'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedSorting == 'category_asc'
                                    ? AppColors.blue600
                                    : Colors.grey[300],
                          ),
                          onPressed: () {
                            setDialogState(() => selectedSorting = 'category_asc');
                          },
                          child: const Text('أ → ي'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedSorting == 'category_desc'
                                    ? AppColors.blue600
                                    : Colors.grey[300],
                          ),
                          onPressed: () {
                            setDialogState(() => selectedSorting = 'category_desc');
                          },
                          child: const Text('ي → أ'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Category filter section
                    Text(
                      _t(context, 'فلتر حسب التصنيف', 'Filter by Category'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: selectedCategory.isEmpty ? 'all' : selectedCategory,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text(_t(context, 'الكل', 'All')),
                        ),
                        ..._getCategoryOptions(context).map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(
                          () => selectedCategory = (value == 'all') ? '' : (value ?? ''),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Price range filter section
                    Text(
                      _t(context, 'نطاق السعر', 'Price Range'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minPriceController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.,]'),
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: _t(context, 'من', 'Min'),
                              hintText: '0',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: maxPriceController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.,]'),
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: _t(context, 'إلى', 'Max'),
                              hintText: '999999',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Reset filters
                    ref.read(sortingTypeProvider.notifier).state = 'none';
                    ref.read(categoryFilterProvider.notifier).state = '';
                    ref.read(priceRangeProvider.notifier).state = (
                      min: 0,
                      max: 999999999,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(_t(context, 'إعادة تعيين', 'Reset')),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(_t(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Apply filters
                    final minPrice = _parseMoneyToIlsCents(
                      minPriceController.text,
                    );
                    final maxPrice = _parseMoneyToIlsCents(
                      maxPriceController.text,
                    );

                    ref.read(sortingTypeProvider.notifier).state =
                        selectedSorting;
                    ref.read(categoryFilterProvider.notifier).state =
                        selectedCategory;
                    ref.read(priceRangeProvider.notifier).state = (
                      min: minPrice,
                      max: maxPrice > 0 ? maxPrice : 999999999,
                    );

                    Navigator.of(context).pop();
                  },
                  child: Text(_t(context, 'تطبيق', 'Apply')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _toggleCostVisibility() async {
    if (_isCostVisible) {
      setState(() {
        _isCostVisible = false;
      });
      return;
    }

    final passwordController = TextEditingController();
    bool isChecking = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_t(context, 'عرض التكلفة', 'Show Cost')),
              content: TextField(
                controller: passwordController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                obscureText: true,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: _t(context, 'كلمة المرور', 'Password'),
                  hintText: _t(context, 'أدخل الرقم السري', 'Enter PIN'),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isChecking
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          _showRecoveryResetDialog();
                        },
                  child: Text(
                    _t(context, 'نسيت كلمة المرور؟', 'Forgot password?'),
                  ),
                ),
                TextButton(
                  onPressed: isChecking
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(_t(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isChecking
                      ? null
                      : () {
                          setDialogState(() {
                            isChecking = true;
                          });

                          final isValid = ref
                              .read(settingsProvider.notifier)
                              .verifyCostPassword(passwordController.text);

                          if (isValid) {
                            setState(() {
                              _isCostVisible = true;
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _t(
                                    context,
                                    'تم إظهار التكلفة بنجاح',
                                    'Cost is now visible',
                                  ),
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            isChecking = false;
                          });
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _t(
                                  context,
                                  'كلمة المرور غير صحيحة',
                                  'Incorrect password',
                                ),
                              ),
                            ),
                          );
                        },
                  child: isChecking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_t(context, 'تأكيد', 'Confirm')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showRecoveryResetDialog() async {
    final recoveryController = TextEditingController();
    final newPasswordController = TextEditingController();
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                _t(
                  context,
                  'استعادة كلمة مرور التكلفة',
                  'Recover Cost Password',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: recoveryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _t(context, 'رمز الاستعادة', 'Recovery Code'),
                      hintText: _t(
                        context,
                        'أدخل رمز الاستعادة (0000)',
                        'Enter recovery code (0000)',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newPasswordController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: _t(
                        context,
                        'كلمة المرور الجديدة',
                        'New Password',
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(_t(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setDialogState(() => isSaving = true);
                          final success = await ref
                              .read(settingsProvider.notifier)
                              .resetCostPasswordWithRecovery(
                                recoveryCode: recoveryController.text,
                                newPassword: newPasswordController.text,
                              );

                          if (!mounted) return;

                          if (success) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _t(
                                    context,
                                    'تم تحديث كلمة المرور بنجاح',
                                    'Password updated successfully',
                                  ),
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isSaving = false);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _t(
                                  context,
                                  'رمز الاستعادة أو كلمة المرور غير صحيحة',
                                  'Recovery code or password is invalid',
                                ),
                              ),
                            ),
                          );
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_t(context, 'حفظ', 'Save')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> showProductDialog({ProductModel? product}) async {
    final isEditing = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final barcodeController = TextEditingController(
      text: product?.barcode ?? '',
    );
    final categoryController = TextEditingController(
      text: product?.category ?? '',
    );
    final sellPriceController = TextEditingController(
      text: product != null ? _centsToInput(product.sellPrice) : '',
    );
    final costPriceController = TextEditingController(
      text: product != null ? _centsToInput(product.costPrice) : '',
    );
    final qtyController = TextEditingController(
      text: (product?.qty ?? 0).toString(),
    );

    bool trackImei = product?.trackImei ?? false;
    bool isSaving = false;
    String? selectedImagePath = product?.imagePath;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final l10n = AppLocalizations.of(context)!;
            return AlertDialog(
              title: Text(isEditing ? l10n.editProduct : l10n.addProduct),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveBreakpoints.maxDialogWidth,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: l10n.name),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: barcodeController,
                        decoration: InputDecoration(
                          labelText: _t(
                            context,
                            'الباركود (اختياري)',
                            'Barcode (optional)',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Autocomplete<String>(
                        initialValue: TextEditingValue(
                          text: categoryController.text,
                        ),
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return _getCategoryOptions(context);
                          }
                          return _getCategoryOptions(context).where(
                            (String option) {
                              return option.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              );
                            },
                          );
                        },
                        onSelected: (String selection) {
                          categoryController.text = selection;
                          if (selection.trim().toLowerCase() != 'phones' &&
                              trackImei) {
                            setDialogState(() => trackImei = false);
                          }
                        },
                        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                          // Sync with our categoryController
                          controller.text = categoryController.text;
                          controller.addListener(() {
                            categoryController.text = controller.text;
                            if (controller.text.trim().toLowerCase() != 'phones' &&
                                trackImei) {
                              setDialogState(() => trackImei = false);
                            }
                          });
                          
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: l10n.category,
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                            ),
                          );
                        },
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
                        decoration: InputDecoration(labelText: l10n.price),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: costPriceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        ],
                        decoration: InputDecoration(labelText: l10n.cost),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: qtyController,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(labelText: l10n.quantity),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Track IMEI'),
                        value: trackImei,
                        onChanged:
                            categoryController.text.trim().toLowerCase() ==
                                'phones'
                            ? (value) {
                                setDialogState(() => trackImei = value);
                              }
                            : null,
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      // Product Image Section
                      Text(
                        _t(context, 'صورة المنتج', 'Product Image'),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      // Image Preview
                      if (selectedImagePath != null &&
                          selectedImagePath!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.file(
                            File(selectedImagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            color: Theme.of(context).disabledColor,
                            size: 40,
                          ),
                        ),
                      const SizedBox(height: 12),
                      // Image Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final result = await FilePicker.platform
                                    .pickFiles(
                                      type: FileType.image,
                                      allowMultiple: false,
                                    );

                                if (result != null &&
                                    result.files.isNotEmpty &&
                                    result.files.first.path != null) {
                                  try {
                                    final productId = isEditing
                                        ? product.id
                                        : const Uuid().v4();
                                    final savedPath =
                                        await ImageStorage.saveProductImage(
                                          productId,
                                          result.files.first,
                                        );
                                    setDialogState(() {
                                      selectedImagePath = savedPath;
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          _t(
                                            context,
                                            'فشل تحميل الصورة: $e',
                                            'Image upload failed: $e',
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.image, size: 18),
                              label: Text(_t(context, 'اختر', 'Choose')),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (selectedImagePath != null &&
                              selectedImagePath!.isNotEmpty)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await ImageStorage.deleteProductImage(
                                    selectedImagePath,
                                  );
                                  setDialogState(() {
                                    selectedImagePath = null;
                                  });
                                },
                                icon: const Icon(Icons.delete, size: 18),
                                label: Text(_t(context, 'حذف', 'Remove')),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                        ],
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
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final name = nameController.text.trim();
                          final barcode = barcodeController.text.trim();
                          final category = categoryController.text.trim();
                          final sellPrice = _parseMoneyToIlsCents(
                            sellPriceController.text,
                          );
                          final costPrice = _parseMoneyToIlsCents(
                            costPriceController.text,
                          );
                          final qty = _parseInt(qtyController.text);

                          if (name.isEmpty || category.isEmpty) {
                            return;
                          }

                          setDialogState(() => isSaving = true);

                          try {
                            final repository = ref.read(
                              productsRepositoryProvider,
                            );
                            if (isEditing) {
                              final updated = product.copyWith(
                                name: name,
                                barcode: barcode.isEmpty ? null : barcode,
                                category: category,
                                sellPrice: sellPrice,
                                costPrice: costPrice,
                                qty: qty,
                                trackImei:
                                    category.toLowerCase() == 'phones' &&
                                    trackImei,
                                imagePath: selectedImagePath,
                                updatedAt: DateTime.now(),
                              );
                              await repository.update(updated);
                            } else {
                              final newProduct = ProductModel(
                                id: const Uuid().v4(),
                                name: name,
                                barcode: barcode.isEmpty ? null : barcode,
                                category: category,
                                sellPrice: sellPrice,
                                costPrice: costPrice,
                                qty: qty,
                                trackImei:
                                    category.toLowerCase() == 'phones' &&
                                    trackImei,
                                imagePath: selectedImagePath,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );
                              await repository.create(newProduct);
                            }

                            // Ensure the products stream refreshes immediately so the
                            // list reflects quantity and other changes without reopen.
                            try {
                              ref.invalidate(filteredProductsStreamProvider);
                              ref.invalidate(productsStreamProvider);
                            } catch (_) {
                              // if invalidate fails for any reason, fall back to the
                              // existing behavior (the stream may update on its own).
                            }

                            if (!mounted) return;
                            Navigator.of(context).pop();
                          } catch (_) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _t(context, 'فشل الحفظ', 'Save failed'),
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
                      : Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> showAdjustStockDialog(ProductModel product) async {
    final qtyController = TextEditingController(text: '0');
    final reasonController = TextEditingController();
    String type = 'Add';
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                _t(
                  context,
                  'تعديل المخزون - ${product.name}',
                  'Adjust Stock - ${product.name}',
                ),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveBreakpoints.maxDialogWidth,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: type,
                        items: const [
                          DropdownMenuItem(
                            value: 'Add',
                            child: Text('Add (+)'),
                          ),
                          DropdownMenuItem(
                            value: 'Remove',
                            child: Text('Remove (-)'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) setDialogState(() => type = value);
                        },
                        decoration: InputDecoration(
                          labelText: _t(
                            context,
                            'نوع العملية',
                            'Operation Type',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: _t(context, 'الكمية', 'Quantity'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: reasonController,
                        decoration: InputDecoration(
                          labelText: _t(context, 'السبب', 'Reason'),
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
                  child: Text(_t(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final qty = _parseInt(qtyController.text);
                          final reason = reasonController.text.trim();

                          if (qty <= 0 || reason.isEmpty) return;

                          setDialogState(() => isSaving = true);

                          try {
                            final repository = ref.read(
                              productsRepositoryProvider,
                            );
                            final delta = type == 'Add' ? qty : -qty;

                            if (delta > 0) {
                              await repository.incrementQuantity(
                                product.id,
                                delta,
                              );
                            } else {
                              await repository.decrementQuantity(
                                product.id,
                                -delta,
                              );
                            }

                            // Also log to stock movements via Drift for now
                            final db = ref.read(dbProvider);
                            await db.adjustStock(
                              productId: product.id,
                              deltaQty: delta,
                              reason: reason,
                            );

                            // No need to invalidate - stream auto-updates
                            if (!mounted) return;
                            Navigator.of(context).pop();
                          } catch (_) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _t(
                                      context,
                                      'فشلت العملية',
                                      'Operation failed',
                                    ),
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
                      : Text(_t(context, 'تأكيد', 'Confirm')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _verifyPasswordForOperation(String operationType) async {
    final passwordController = TextEditingController();
    bool isChecking = false;
    bool? result;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_t(context, 'تأكيد العملية', 'Confirm Operation')),
              content: TextField(
                controller: passwordController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                obscureText: true,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: _t(context, 'كلمة المرور', 'Password'),
                  hintText: _t(context, 'أدخل الرقم السري', 'Enter PIN'),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isChecking
                      ? null
                      : () {
                          result = false;
                          Navigator.of(context).pop();
                        },
                  child: Text(_t(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  onPressed: isChecking
                      ? null
                      : () {
                          setDialogState(() {
                            isChecking = true;
                          });

                          final isValid = ref
                              .read(settingsProvider.notifier)
                              .verifyCostPassword(passwordController.text);

                          if (isValid) {
                            result = true;
                            Navigator.of(context).pop();
                            return;
                          }

                          setDialogState(() {
                            isChecking = false;
                          });
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _t(
                                  context,
                                  'كلمة المرور غير صحيحة',
                                  'Incorrect password',
                                ),
                              ),
                            ),
                          );
                        },
                  child: isChecking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_t(context, 'تأكيد', 'Confirm')),
                ),
              ],
            );
          },
        );
      },
    );

    return result ?? false;
  }

  Future<void> _showDeleteProductDialog(ProductModel product) async {
    // Verify password first
    final isAuthorized = await _verifyPasswordForOperation('delete');
    if (!isAuthorized) return;

    bool isDeleting = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_t(context, 'حذف المنتج', 'Delete Product')),
              content: Text(
                _t(
                  context,
                  'هل أنت متأكد من حذف المنتج "${product.name}"؟',
                  'Are you sure you want to delete "${product.name}"?',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(_t(context, 'إلغاء', 'Cancel')),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isDeleting
                      ? null
                      : () async {
                          setDialogState(() => isDeleting = true);

                          try {
                            final repository = ref.read(
                              productsRepositoryProvider,
                            );
                            await repository.delete(product.id);

                            if (product.imagePath != null &&
                                product.imagePath!.isNotEmpty) {
                              await ImageStorage.deleteProductImage(
                                product.imagePath,
                              );
                            }

                            // Invalidate the products stream to refresh immediately
                            ref.invalidate(filteredProductsStreamProvider);
                            ref.invalidate(productsStreamProvider);

                            if (!mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _t(
                                    context,
                                    'تم حذف المنتج بنجاح',
                                    'Product deleted successfully',
                                  ),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            setDialogState(() => isDeleting = false);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _t(
                                    context,
                                    'فشل حذف المنتج: $e',
                                    'Failed to delete product: $e',
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: isDeleting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_t(context, 'حذف', 'Delete')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showProduct = showProductDialog;

    return Consumer(
      builder: (context, ref, child) {
        final inventoryStatsAsync = ref.watch(productsStreamProvider);
        return GradientScaffold(
          appBar: AppTopBar(title: l10n.inventory),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppCard(
                      padding: const EdgeInsets.all(12),
                      child: inventoryStatsAsync.when(
                        data: (products) {
                          final stats = _calculateInventoryStats(products);
                          return Row(
                            children: [
                              Expanded(
                                child: _buildSummaryTile(
                                  context: context,
                                  title: _t(context, 'عدد الأصناف', 'Item Types'),
                                  value: stats.categoryCount.toString(),
                                  icon: Icons.category_outlined,
                                  color: AppColors.blue600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildSummaryTile(
                                  context: context,
                                  title: _t(context, 'عدد المنتجات', 'Products Count'),
                                  value: stats.productCount.toString(),
                                  icon: Icons.inventory_2_outlined,
                                  color: AppColors.green600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildSummaryTile(
                                  context: context,
                                  title: _t(
                                    context,
                                    'إجمالي سعر البيع',
                                    'Total Sell Value',
                                  ),
                                  value: formatMoneyCents(
                                    stats.totalSellValueCents,
                                  ),
                                  icon: Icons.sell_outlined,
                                  color: AppColors.yellow600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildSummaryTile(
                                  context: context,
                                  title: _t(
                                    context,
                                    'إجمالي الجملة',
                                    'Total Wholesale Value',
                                  ),
                                  value: formatMoneyCents(
                                    stats.totalCostValueCents,
                                  ),
                                  icon: Icons.payments_outlined,
                                  color: AppColors.purple600,
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (_, _) => Text(
                          _t(context, 'تعذر تحميل الإحصائيات', 'Failed to load stats'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: _t(
                                  context,
                                  'ابحث بالاسم، التصنيف، السعر، الباركود...',
                                  'Search by name, category, price, barcode...',
                                ),
                                filled: true,
                                fillColor: Theme.of(
                                  context,
                                ).inputDecorationTheme.fillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (value) {
                                ref
                                        .read(
                                          inventorySearchQueryProvider.notifier,
                                        )
                                        .state =
                                    value;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.filter_list),
                            label: Text(
                              _t(context, 'فلاتر', 'Filters'),
                            ),
                            onPressed: _showFilterDialog,
                          ),
                          const SizedBox(width: 8),
                          GradientButton(
                            label: l10n.addProduct,
                            icon: Icons.add,
                            onPressed: () => showProduct(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: AppCard(
                        padding: EdgeInsets.zero,
                        child: ref
                            .watch(filteredProductsStreamProvider)
                            .when(
                              data: (products) {
                                if (products.isEmpty) {
                                  return Center(
                                    child: Text(
                                      _t(
                                        context,
                                        'لا توجد منتجات',
                                        'No products found',
                                      ),
                                    ),
                                  );
                                }

                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    cardColor: Theme.of(context).cardColor,
                                    dividerColor: Theme.of(
                                      context,
                                    ).dividerColor,
                                  ),
                                  child: SingleChildScrollView(
                                    child: DataTable(
                                      headingRowColor: WidgetStateProperty.all(
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainer,
                                      ),
                                      dataRowMinHeight: 60,
                                      dataRowMaxHeight: 60,
                                      columns: [
                                        DataColumn(label: Text(l10n.name)),
                                        DataColumn(label: Text(l10n.category)),
                                        DataColumn(label: Text(l10n.price)),
                                        DataColumn(
                                          label: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            onTap: _toggleCostVisibility,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(l10n.cost),
                                                const SizedBox(width: 6),
                                                Icon(
                                                  _isCostVisible
                                                      ? Icons.lock_open
                                                      : Icons.lock_outline,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        DataColumn(label: Text(l10n.quantity)),
                                        DataColumn(label: Text(l10n.actions)),
                                      ],
                                      rows: products.map((product) {
                                        // Product image widget
                                        final imageWidget =
                                            product.imagePath != null &&
                                                product.imagePath!.isNotEmpty
                                            ? Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  image: DecorationImage(
                                                    image: FileImage(
                                                      File(product.imagePath!),
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: AppColors.blue600
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Icon(
                                                  Icons.inventory_2_outlined,
                                                  size: 20,
                                                  color: AppColors.blue600,
                                                ),
                                              );

                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Row(
                                                children: [
                                                  imageWidget,
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    product.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              Chip(
                                                      label: Text(
                                                        _localizedCategory(
                                                          product.category,
                                                          context,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .surfaceContainerHighest,
                                                      labelStyle: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                            ),
                                            DataCell(
                                              Text(
                                                formatMoneyCents(
                                                  product.sellPrice,
                                                ),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              _isCostVisible
                                                  ? Text(
                                                      formatMoneyCents(
                                                        product.costPrice,
                                                      ),
                                                    )
                                                  : const Text('••••••'),
                                            ),
                                            DataCell(
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: product.qty > 0
                                                      ? Colors.green
                                                            .withOpacity(0.1)
                                                      : Colors.red.withOpacity(
                                                          0.1,
                                                        ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '${product.qty}',
                                                  style: TextStyle(
                                                    color: product.qty > 0
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                      color: Colors.blue,
                                                    ),
                                                    onPressed: () async {
                                                      final isAuthorized =
                                                          await _verifyPasswordForOperation(
                                                              'edit');
                                                      if (isAuthorized) {
                                                        showProduct(
                                                          product: product,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () =>
                                                        _showDeleteProductDialog(
                                                          product,
                                                        ),
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
                              error: (error, stack) => AppErrorState(
                                message: 'Failed to load products',
                                details: error.toString(),
                                stackTrace: stack,
                                onRetry: () => ref.invalidate(
                                  filteredProductsStreamProvider,
                                ),
                              ),
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _localizedCategory(String? category, BuildContext context) {
    if (category == null || category.trim().isEmpty) return '-';
    
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    // Check if it's one of our predefined categories
    for (final cat in _predefinedCategories) {
      final arName = cat['ar']!;
      final enName = cat['en']!;
      
      // If the category matches either Arabic or English name
      if (category.toLowerCase() == arName.toLowerCase() ||
          category.toLowerCase() == enName.toLowerCase()) {
        return isArabic ? arName : enName;
      }
    }
    
    // For backward compatibility with old categories
    final cat = category.toLowerCase();
    final l10n = AppLocalizations.of(context)!;

    switch (cat) {
      case 'smartphones':
      case 'phones':
        return l10n.category_smartphones;
      case 'electrical':
      case 'electronics':
        return l10n.category_electrical;
      default:
        return category;
    }
  }
}
