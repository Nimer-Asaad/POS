import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pos_store/core/formatting/money.dart';
import 'package:pos_store/core/business_logic/service_profit_calculator.dart';
import 'package:pos_store/design/app_spacing.dart';
import 'package:pos_store/providers/service_transactions_provider.dart';
import 'package:pos_store/features/pos/presentation/widgets/telelink_form.dart';

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

class ServicesPanel extends ConsumerStatefulWidget {
  final void Function({
    required String category,
    required String provider,
    required String providerLabel,
    required int amountCents,
    int? profitCents,
    String? notes,
    String? customerName,
  })?
  onAddServiceItem;

  const ServicesPanel({super.key, this.onAddServiceItem});

  @override
  ConsumerState<ServicesPanel> createState() => _ServicesPanelState();
}

class _ServicesPanelState extends ConsumerState<ServicesPanel> {
  String _selectedCategory = 'websites'; // websites or palpay
  late String _selectedProvider;
  String _platformType = 'balance'; // balance, bundle, roaming
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _providerSearchController = TextEditingController();
  final _customerNameController = TextEditingController();
  String _customProviderLabel = '';
  String _providerSearch = '';

  @override
  void initState() {
    super.initState();
    _selectedProvider = 'telelink'; // default for websites
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _providerSearchController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  List<String> _getProvidersForCategory(String category) {
    if (category == 'websites') {
      return ['telelink', 'platform', 'fawry', 'farahnet'];
    } else {
      return ['electricity', 'mada', 'other'];
    }
  }

  String _getProviderLabel(String provider) {
    final labels = {
      'telelink': _lang(context, 'تيليلينك', 'Telelink'),
      'platform': _lang(context, 'المنصة الإلكترونية', 'E-Platform'),
      'fawry': _lang(context, 'فوري', 'Fawry'),
      'farahnet': _lang(context, 'فرح نت', 'FarahNet'),
      'electricity': _lang(context, 'كهرباء', 'Electricity'),
      'mada': _lang(context, 'مدى', 'Mada'),
      'other': _lang(context, 'خدمة أخرى', 'Other Service'),
    };
    return labels[provider] ?? provider;
  }

  String _getPlatformTypeLabel(String type) {
    final labels = {
      'balance': _lang(context, 'رصيد', 'Balance'),
      'bundle': _lang(context, 'حزم', 'Bundles'),
      'roaming': _lang(context, 'تجوال', 'Roaming'),
    };
    return labels[type] ?? type;
  }

  Future<void> _submitTransaction() async {
    final amount = (_parseMoneyToIls(_amountController.text) * 100).round();

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

    String providerLabel = _selectedProvider == 'other'
        ? _customProviderLabel.trim()
        : _getProviderLabel(_selectedProvider);

    if (_selectedProvider == 'platform') {
      providerLabel += ' - ${_getPlatformTypeLabel(_platformType)}';
    }

    if (providerLabel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(context, 'يجب إدخال اسم الخدمة', 'Must enter service name'),
          ),
        ),
      );
      return;
    }

    // Calculate profit using service profit calculator
    String serviceType = _getServiceType();
    int providerCostCents = _getEstimatedProviderCost(amount, serviceType);

    final profitResult = calculateServiceProfit(
      ServiceProfitInput(
        amountCents: amount,
        providerCostCents: providerCostCents,
        serviceType: serviceType,
        provider: _selectedProvider,
        subService: null,
      ),
    );

    int profitCents = profitResult.finalProfit;

    // Show warning if loss or low profit
    if (mounted && (profitResult.isLoss || profitResult.isLow)) {
      if (profitResult.warning.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profitResult.warning),
            backgroundColor: profitResult.isLoss ? Colors.red : Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    if (widget.onAddServiceItem != null) {
      // Note: onAddServiceItem signature doesn't support profitCents easily
      // without changing the callback. For now, since cart items in POS
      // are turned into sales, profit logic for those might need to be
      // handled when converting cart to sale, OR we assume POS services
      // just track revenue. But the requirement is for daily inventory profit.
      // If added to cart, it eventually becomes a service transaction via checkout.
      // I should update PosScreen to handle this, but for now I'll just pass
      // amount and let the actual transaction recording handle profit if possible.
      // Wait, PosScreen._checkout calls addServiceTransaction too.
      // I should pass profit to the callback if I can, or update the callback signature.
      // The prompt implies these are immediate service transactions usually,
      // or if part of POS, they are checkout out.

      // I'll update the callback signature in the file too to be safe.
      widget.onAddServiceItem!(
        category: _selectedCategory,
        provider: _selectedProvider,
        providerLabel: providerLabel,
        amountCents: amount,
        profitCents: profitCents,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        customerName: _customerNameController.text.isNotEmpty ? _customerNameController.text.trim() : null,
      );

      _amountController.clear();
      _notesController.clear();
      _customerNameController.clear();
      _customProviderLabel = '';
      // Reset telelink type to default just in case, or keep it
      // _telelinkType = 'bills';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(context, 'تمت إضافة الخدمة للسلة', 'Service added to cart'),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      return;
    }

    try {
      await ref
          .read(serviceTransactionControllerProvider.notifier)
          .addServiceTransaction(
            category: _selectedCategory,
            provider: _selectedProvider,
            providerLabel: providerLabel,
            customerName: _customerNameController.text.isNotEmpty ? _customerNameController.text.trim() : null,
            amountCents: amount,
            profitCents: profitCents,
            notes: _notesController.text.isNotEmpty
                ? _notesController.text
                : null,
          );

      // Clear form except provider
      _amountController.clear();
      _notesController.clear();
      _customerNameController.clear();
      _customProviderLabel = '';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_lang(context, 'تم حفظ العملية', 'Transaction saved')}: $providerLabel',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_lang(context, 'خطأ', 'Error')}: $e')),
        );
      }
    }
  }

  Future<void> _openCashDrawer() async {
    try {
      await ref
          .read(serviceTransactionControllerProvider.notifier)
          .openCashDrawer(
            notes: _notesController.text.isNotEmpty
                ? _notesController.text
                : null,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_lang(context, 'تم فتح الكاش', 'Cash drawer opened')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_lang(context, 'خطأ', 'Error')}: $e')),
        );
      }
    }
  }

  double _parseMoneyToIls(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0.0;
    final normalized = trimmed.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  Widget _buildProfitRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey[400],
            letterSpacing: 0.3,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: isBold ? FontWeight.bold : null,
            color: valueColor,
            fontSize: isBold ? 13 : 12,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  String _getServiceType() {
    if (_selectedProvider == 'electricity') {
      return 'electricity';
    } else if (_selectedProvider == 'platform') {
      return _platformType; // balance, bundle, roaming
    } else if (_selectedProvider == 'fawry') {
      return 'bills';
    } else if (_selectedProvider == 'farahnet') {
      return 'internet';
    } else if (_selectedCategory == 'palpay') {
      return 'balance'; // payment service
    }
    return 'bills'; // default
  }

  int _getEstimatedProviderCost(int amountCents, String serviceType) {
    // These are estimated provider costs based on historical margins.
    // In production, these should be fetched from a configuration table
    // or provider cost configuration service.
    // All percentages represent the cost the store pays to the provider.

    double costPercentage = 0.0;

    if (serviceType == 'games') {
      // Games: typically 85-90% cost
      costPercentage = 0.88;
    } else if (serviceType == 'bills') {
      // Bills: typically 98-99% cost
      costPercentage = 0.985;
    } else if (serviceType == 'balance') {
      // Balance: 3.00% profit (same as Telelink)
      costPercentage = 0.97;
    } else if (serviceType == 'electricity') {
      // Electricity: fixed fee + percentage
      // For simplicity: estimate as 99% cost
      costPercentage = 0.99;
    } else if (serviceType == 'internet' || serviceType == 'bundle') {
      // Bundles for platform: 3.26% profit (same as Telelink)
      // Other bundle/internet providers keep near historical margin
      if (_selectedProvider == 'platform' && serviceType == 'bundle') {
        costPercentage = 0.9674;
      } else {
        costPercentage = 0.98;
      }
    } else if (serviceType == 'roaming' || serviceType == 'minutes') {
      // Roaming for platform: 4.39% profit (same as Telelink)
      if (_selectedProvider == 'platform' && serviceType == 'roaming') {
        costPercentage = 0.9561;
      } else {
        costPercentage = 0.96;
      }
    }

    return (amountCents * costPercentage).round();
  }

  ServiceProfitOutput? _getCurrentProfitPreview() {
    final amount = (_parseMoneyToIls(_amountController.text) * 100).round();
    if (amount <= 0) return null;

    String serviceType = _getServiceType();
    int providerCostCents = _getEstimatedProviderCost(amount, serviceType);

    return calculateServiceProfit(
      ServiceProfitInput(
        amountCents: amount,
        providerCostCents: providerCostCents,
        serviceType: serviceType,
        provider: _selectedProvider,
        subService: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final providers = _getProvidersForCategory(_selectedCategory);
    final todayTransactions = ref.watch(todayServiceTransactionsProvider);
    final providerSearch = _providerSearch.trim().toLowerCase();
    final filteredProviders = providerSearch.isEmpty
        ? providers
        : providers.where((provider) {
            final label = _getProviderLabel(provider).toLowerCase();
            return label.contains(providerSearch) ||
                provider.toLowerCase().contains(providerSearch);
          }).toList();

    // Update provider if current one is not in new list
    if (!providers.contains(_selectedProvider)) {
      _selectedProvider = providers.first;
    }

    return Card(
      margin: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
        top: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
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
                    _lang(context, 'الخدمات والصندوق', 'Services and Drawer'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _openCashDrawer,
                    icon: const Icon(Icons.money_off),
                    label: Text(_lang(context, 'فتح الكاش', 'Open Drawer')),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Category Toggle
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: [
                        ButtonSegment(
                          value: 'websites',
                          label: Text(
                            _lang(context, 'مواقع إلكترونية', 'Websites'),
                          ),
                        ),
                        ButtonSegment(
                          value: 'palpay',
                          label: Text(_lang(context, 'بال باي', 'PAL Payment')),
                        ),
                      ],
                      selected: {_selectedCategory},
                      onSelectionChanged: (selected) {
                        setState(() {
                          _selectedCategory = selected.first;
                          _selectedProvider = _getProvidersForCategory(
                            _selectedCategory,
                          ).first;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Provider Search
              TextField(
                controller: _providerSearchController,
                onChanged: (value) {
                  setState(() {
                    _providerSearch = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: _lang(
                    context,
                    'بحث عن خدمة',
                    'Search for service',
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Provider Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _lang(context, 'الخدمة', 'Service'),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  if (filteredProviders.isEmpty)
                    Text(
                      _lang(context, 'لا توجد نتائج', 'No results'),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    )
                  else
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: filteredProviders.map((provider) {
                        final isSelected = _selectedProvider == provider;
                        return Container(
                          decoration: isSelected
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                )
                              : null,
                          child: FilterChip(
                            label: Text(
                              _getProviderLabel(provider),
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w600 : null,
                              ),
                            ),
                            selected: isSelected,
                            backgroundColor: Colors.transparent,
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.blue.withOpacity(0.8)
                                  : Colors.grey.withOpacity(0.3),
                              width: isSelected ? 1.5 : 1,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                _selectedProvider = provider;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Custom Provider Label (for 'other')
              if (_selectedProvider == 'other')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _customProviderLabel = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: _lang(context, 'اسم الخدمة', 'Service Name'),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),

              // Platform Type Selection
              if (_selectedProvider == 'platform')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _lang(context, 'نوع شحن المنصة', 'Platform Charge Type'),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(
                          value: 'balance',
                          label: Text(_lang(context, 'رصيد 3%', 'Balance 3%')),
                        ),
                        ButtonSegment(
                          value: 'bundle',
                          label: Text(_lang(context, 'حزم 3.26%', 'Bundles 3.26%')),
                        ),
                        ButtonSegment(
                          value: 'roaming',
                          label: Text(_lang(context, 'تجوال 4.39%', 'Roaming 4.39%')),
                        ),
                      ],
                      selected: {_platformType},
                      onSelectionChanged: (selected) {
                        setState(() {
                          _platformType = selected.first;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),

              // Conditional: Show TelelinkForm for Telelink provider
              if (_selectedProvider == 'telelink')
                TelelinkForm(
                  onAddService:
                      ({
                        required category,
                        required provider,
                        required providerLabel,
                        required amountCents,
                        required profitCents,
                        notes,
                      }) {
                        if (widget.onAddServiceItem != null) {
                          widget.onAddServiceItem!(
                            category: category,
                            provider: provider,
                            providerLabel: providerLabel,
                            amountCents: amountCents,
                            profitCents: profitCents,
                            notes: notes,
                          );
                        }

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _lang(
                                  context,
                                  'تمت إضافة الخدمة للسلة',
                                  'Service added to cart',
                                ),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                  },
                )
              else ...[
                // Regular Input Fields (for non-Telelink providers)
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) =>
                      setState(() {}), // Trigger rebuild for profit preview
                  decoration: InputDecoration(
                    labelText: _lang(context, 'المبلغ (₪)', 'Amount (₪)'),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Profit Preview Box - Premium Dark Mode Glassmorphism
                Consumer(
                  builder: (context, ref, child) {
                    final profitPreview = _getCurrentProfitPreview();

                    if (profitPreview == null) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (!profitPreview.isLoss && !profitPreview.isLow)
                            BoxShadow(
                              color: Colors.green.withOpacity(0.15),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                          if (profitPreview.isLow && !profitPreview.isLoss)
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.15),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                          if (profitPreview.isLoss)
                            BoxShadow(
                              color: Colors.red.withOpacity(0.15),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.grey[900]!.withOpacity(0.4),
                              border: Border.all(
                                color: profitPreview.isLoss
                                    ? Colors.red.withOpacity(0.5)
                                    : profitPreview.isLow
                                    ? Colors.orange.withOpacity(0.5)
                                    : Colors.green.withOpacity(0.5),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with games bonus badge
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _lang(
                                        context,
                                        'معلومات الربح',
                                        'Profit Info',
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                    if (profitPreview.hasBonus)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.purple.withOpacity(0.9),
                                              Colors.deepPurple.withOpacity(
                                                0.9,
                                              ),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.purple.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 12,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              '🎮',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              _lang(
                                                context,
                                                '+1₪ مكافأة',
                                                '+1₪ Bonus',
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white70,
                                                    letterSpacing: 0.3,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Profit breakdown with improved spacing
                                _buildProfitRow(
                                  context,
                                  _lang(context, 'التكلفة', 'Cost'),
                                  formatMoneyCents(
                                    profitPreview.baseProfit +
                                        (profitPreview.finalProfit -
                                            profitPreview.baseProfit -
                                            profitPreview.bonusProfit),
                                  ),
                                  Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                _buildProfitRow(
                                  context,
                                  _lang(
                                    context,
                                    'الربح المتوقع',
                                    'Expected Profit',
                                  ),
                                  formatMoneyCents(profitPreview.finalProfit),
                                  profitPreview.isLoss
                                      ? Colors.red
                                      : profitPreview.isLow
                                      ? Colors.orange
                                      : Colors.green,
                                  isBold: true,
                                ),
                                const SizedBox(height: 8),
                                _buildProfitRow(
                                  context,
                                  _lang(context, 'نسبة الربح', 'Profit %'),
                                  '${profitPreview.profitPercent.toStringAsFixed(2)}%',
                                  Colors.cyan,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                TextField(
                  controller: _customerNameController,
                  decoration: InputDecoration(
                    labelText: _lang(
                      context,
                      'اسم العميل (اختياري)',
                      'Customer Name (Optional)',
                    ),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: _lang(
                      context,
                      'ملاحظات (اختيارية)',
                      'Notes (Optional)',
                    ),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _submitTransaction,
                        icon: const Icon(Icons.check),
                        label: Text(
                          widget.onAddServiceItem != null
                              ? _lang(context, 'إضافة للسلة', 'Add to Cart')
                              : _lang(context, 'تنفيذ عملية', 'Complete'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),

              // Today's History
              Text(
                _lang(context, 'آخر العمليات', 'Recent Transactions'),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 120,
                child: todayTransactions.when(
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return Center(
                        child: Text(
                          _lang(
                            context,
                            'لا توجد عمليات اليوم',
                            'No transactions today',
                          ),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final timeFormat = DateFormat('HH:mm');
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            tx.providerLabel ?? _getProviderLabel(tx.provider),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          subtitle: Text(
                            tx.customerName ??
                                _lang(context, 'بدون عميل', 'No customer'),
                            style: Theme.of(context).textTheme.labelSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatMoneyCents(tx.amountCents),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (tx.profitCents != null &&
                                      tx.profitCents! > 0)
                                    Text(
                                      '(${formatMoneyCents(tx.profitCents!)}) ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Colors.green,
                                            fontSize: 10,
                                          ),
                                    ),
                                  Text(
                                    timeFormat.format(tx.createdAt),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('${_lang(context, 'خطأ', 'Error')}: $error'),
                  ),
                ),
              ),

              // View All Button
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to detailed transactions view
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _lang(
                            context,
                            'سيتم إضافة صفحة التفاصيل قريباً',
                            'Details page coming soon',
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(_lang(context, 'عرض الكل', 'View All')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
