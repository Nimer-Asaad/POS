import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_store/l10n/app_localizations.dart';
import 'package:printing/printing.dart';

import '../../../core/constants/responsive_breakpoints.dart';
import '../../../core/formatting/money.dart';
import '../../../data/db/app_database.dart';
import '../../../providers/db_provider.dart';
import '../../../core/utils/print_service.dart';
import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_top_bar.dart';
import '../../../core/ui/widgets/gradient_scaffold.dart';
import '../../../core/ui/widgets/gradient_button.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/ui/widgets/responsive_dialog.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import 'widgets/pos_product_card.dart';
import 'widgets/services_panel.dart';
import 'widgets/side_revenue_form.dart';
import 'widgets/product_details_dialog.dart';
import '../../customers/presentation/add_customer_dialog.dart';
import '../../../design/app_colors.dart';
import '../../../providers/service_transactions_provider.dart';

final posSearchQueryProvider = StateProvider<String>((ref) => '');

final posSearchResultsProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final db = ref.watch(dbProvider);
  final query = ref.watch(posSearchQueryProvider);
  return db.searchProducts(query);
});

final posCustomerSearchProvider = StateProvider<String>((ref) => '');

final posCustomersProvider = StreamProvider.autoDispose<List<Customer>>((ref) {
  final db = ref.watch(dbProvider);
  final query = ref.watch(posCustomerSearchProvider);
  return db.watchCustomers(query);
});

final posSelectedCustomerIdProvider = StateProvider<String?>((ref) => null);

String _lang(BuildContext context, String ar, String en) {
  return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
}

final posCartProvider =
    StateNotifierProvider<PosCartNotifier, Map<String, CartItem>>(
      (ref) => PosCartNotifier(),
    );

// Cart Item Model
class CartItem {
  final Product product;
  final int qty;

  const CartItem({required this.product, required this.qty});

  int get lineTotal => qty * product.sellPrice;

  CartItem copyWith({int? qty}) {
    return CartItem(product: product, qty: qty ?? this.qty);
  }
}

// Cart State Notifier
class PosCartNotifier extends StateNotifier<Map<String, CartItem>> {
  PosCartNotifier() : super(const {});

  void add(Product product) {
    final existing = state[product.id];
    if (existing == null) {
      state = {...state, product.id: CartItem(product: product, qty: 1)};
      return;
    }

    state = {...state, product.id: existing.copyWith(qty: existing.qty + 1)};
  }

  void increment(String productId) {
    final existing = state[productId];
    if (existing == null) {
      return;
    }

    state = {...state, productId: existing.copyWith(qty: existing.qty + 1)};
  }

  void decrement(String productId) {
    final existing = state[productId];
    if (existing == null) {
      return;
    }

    if (existing.qty <= 1) {
      final updated = Map<String, CartItem>.from(state)..remove(productId);
      state = updated;
      return;
    }

    state = {...state, productId: existing.copyWith(qty: existing.qty - 1)};
  }

  void clear() {
    state = {};
  }
}

class ServiceCartItem {
  final String id;
  final String category;
  final String provider;
  final String providerLabel;
  final int amountCents;
  final int? profitCents;
  final String? notes;
  final String? customerName;

  const ServiceCartItem({
    required this.id,
    required this.category,
    required this.provider,
    required this.providerLabel,
    required this.amountCents,
    this.profitCents,
    this.notes,
    this.customerName,
  });
}

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _discountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _paidController = TextEditingController(
    text: '0',
  );

  int _discount = 0;
  int _paid = 0;
  String _paymentType = 'Cash';
  bool _isCheckingOut = false;
  String? _lastSaleId;
  final List<ServiceCartItem> _serviceItems = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _discountController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  //ignore: unused_element
  int _parseInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 0;
    }
    return int.tryParse(trimmed) ?? 0;
  }

  /// Convert ILS string input (e.g., "20.5") to cents (2050)
  int _parseMoneyToIlsCents(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 0;
    }
    // Replace comma with dot for decimal input
    final normalized = trimmed.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) {
      return 0;
    }
    return (parsed * 100).round();
  }

  String _formatCents(int cents) => formatMoneyCents(cents);

  String? _discountViolationMessage(
    List<CartItem> items,
    int subtotal,
    int discount,
  ) {
    if (subtotal <= 0) {
      return null;
    }

    if (discount > subtotal) {
      return 'Discount cannot exceed subtotal.';
    }

    for (final item in items) {
      final itemGross = item.product.sellPrice * item.qty;
      final itemDiscount = ((discount * itemGross) / subtotal).round();
      final itemNet = itemGross - itemDiscount;
      final effectiveUnitNet = itemNet ~/ item.qty;
      if (effectiveUnitNet < item.product.costPrice) {
        final difference = item.product.costPrice - effectiveUnitNet;
        return "Discount rejected because discounted unit price is below cost.\n"
            "Product: ${item.product.name}\n"
            "Cost price: ${_formatCents(item.product.costPrice)}\n"
            "Discounted price: ${_formatCents(effectiveUnitNet)}\n"
            "Difference: ${_formatCents(difference)}";
      }
    }

    return null;
  }

  double _servicesPanelHeight(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.isMobile(size.width);

    if (isMobile) {
      if (size.height < 700) {
        return 170;
      }
      if (size.height < 850) {
        return 200;
      }
      return 220;
    }

    if (size.height < 700) {
      return 260;
    }
    if (size.height < 900) {
      return 300;
    }
    return 340;
  }

  Future<bool> _confirmMoveRemainingToDebt(int remaining) async {
    final formatted = _formatCents(remaining);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            _lang(context, 'تحويل المتبقي للديون؟', 'Move remaining to debt?'),
          ),
          content: Text(
            _lang(
              context,
              'سيتم تحويل $formatted إلى الديون. هل تريد المتابعة؟',
              '$formatted will be moved to debt. Continue?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(_lang(context, 'إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(_lang(context, 'تأكيد', 'Confirm')),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _checkout() async {
    final cartMap = ref.read(posCartProvider);
    if (cartMap.isEmpty && _serviceItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }

    final cartItems = cartMap.values.toList();
    final productSubtotal = cartItems.fold<int>(
      0,
      (sum, item) => sum + item.lineTotal,
    );
    final serviceSubtotal = _serviceItems.fold<int>(
      0,
      (sum, item) => sum + item.amountCents,
    );
    final total = productSubtotal - _discount + serviceSubtotal;
    final selectedCustomerId = ref.read(posSelectedCustomerIdProvider);
    final discountViolation = _discountViolationMessage(
      cartItems,
      productSubtotal,
      _discount,
    );

    if (productSubtotal == 0 && _discount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(
              context,
              'لا يوجد منتجات لتطبيق الخصم',
              'No products to discount',
            ),
          ),
        ),
      );
      return;
    }

    if (_discount > productSubtotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Discount cannot exceed subtotal')),
      );
      return;
    }

    if (_paid < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paid amount must be positive')),
      );
      return;
    }

    if (discountViolation != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(discountViolation)));
      return;
    }

    if (_paid < total) {
      if (selectedCustomerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _lang(
                context,
                'اختر عميل لتحويل المتبقي إلى الديون',
                'Select a customer to move remaining amount to debt',
              ),
            ),
          ),
        );
        return;
      }

      final confirmed = await _confirmMoveRemainingToDebt(total - _paid);
      if (!confirmed) {
        return;
      }
    }

    if (_paymentType == 'Credit' && selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a customer for credit sales')),
      );
      return;
    }

    setState(() {
      _isCheckingOut = true;
    });

    try {
      final db = ref.read(dbProvider);
      String? saleId;
      if (cartItems.isNotEmpty) {
        final items = cartItems
            .map(
              (item) => SaleCheckoutItem(
                productId: item.product.id,
                qty: item.qty,
                unitPrice: item.product.sellPrice,
              ),
            )
            .toList();

        saleId = await db.checkoutSale(
          items: items,
          customerId: selectedCustomerId,
          discount: _discount,
          paid: _paid,
          paymentType: _paymentType,
        );
      }

      if (_serviceItems.isNotEmpty) {
        final notifier = ref.read(
          serviceTransactionControllerProvider.notifier,
        );

        // Get customer name if customer is selected
        String? selectedCustomerName;
        if (selectedCustomerId != null) {
          try {
            final customer =
                await (db.select(db.customers)
                      ..where((tbl) => tbl.id.equals(selectedCustomerId)))
                    .getSingleOrNull();
            if (customer != null) {
              selectedCustomerName = customer.name;
            }
          } catch (_) {
            // Ignore errors getting customer name
          }
        }

        for (final item in _serviceItems) {
          await notifier.addServiceTransaction(
            category: item.category,
            provider: item.provider,
            providerLabel: item.providerLabel,
            customerName: item.customerName ?? selectedCustomerName,
            amountCents: item.amountCents,
            profitCents: item.profitCents,
            notes: item.notes,
            saleId: saleId,
          );
        }
      }

      try {
        await ref
            .read(serviceTransactionControllerProvider.notifier)
            .openCashDrawer(
              notes: saleId != null
                  ? 'POS sale ${saleId.substring(0, 6)}'
                  : 'POS services',
            );
      } catch (_) {
        // Cash drawer failures should not block checkout.
      }

      ref.read(posCartProvider.notifier).clear();
      ref.invalidate(dashboardDataProvider);
      setState(() {
        _serviceItems.clear();
        _discount = 0;
        _paid = 0;
        _paymentType = 'Cash';
        ref.read(posSelectedCustomerIdProvider.notifier).state = null;
        _discountController.text = '0';
        _paidController.text = '0';
        _lastSaleId = saleId;
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang(
              context,
              'تمت عملية البيع - للطباعة استخدم زر الطباعة فقط',
              'Sale completed - use the Print button only',
            ),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Checkout failed')));
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingOut = false;
        });
      }
    }
  }

  void _showSaleInvoicePreview(String saleId) {
    final printService = PrintService(ref.read(dbProvider));

    showDialog(
      context: context,
      builder: (context) => ResponsiveDialog(
        child: PdfPreview(
          build: (format) => printService.buildSaleInvoicePdf(saleId),
        ),
      ),
    );
  }

  void _showProductDetails(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) {
    // Add product directly to cart without dialog
    ref.read(posCartProvider.notifier).add(product);
  }

  void _showCartItemDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) =>
          ProductDetailsDialog(product: product, onClose: () {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(posCartProvider).values.toList();
    // Get customer if needed elsewhere in the code
    final _ = ref.watch(posCustomersProvider);
    final selectedCustomerId = ref.watch(posSelectedCustomerIdProvider);
    final productSubtotal = cartItems.fold<int>(
      0,
      (sum, item) => sum + item.lineTotal,
    );
    final serviceSubtotal = _serviceItems.fold<int>(
      0,
      (sum, item) => sum + item.amountCents,
    );
    final subtotal = productSubtotal + serviceSubtotal;
    final total = productSubtotal - _discount + serviceSubtotal;
    // Change calculation: never negative
    // Calculate change if needed for display
    final _ = _paymentType == 'Credit'
        ? 0
        : (_paid >= total ? _paid - total : 0);
    final discountWarning = _discountViolationMessage(
      cartItems,
      productSubtotal,
      _discount,
    );
    // Check if checkout should be disabled
    final requiresCustomerForDebt = _paid < total;
    final requiresCustomerForCredit = _paymentType == 'Credit';
    final hasCustomer = selectedCustomerId != null;
    final hasItems = cartItems.isNotEmpty || _serviceItems.isNotEmpty;
    final canCheckout =
        hasItems &&
        discountWarning == null &&
        !_isCheckingOut &&
        (!requiresCustomerForDebt || hasCustomer) &&
        (!requiresCustomerForCredit || hasCustomer);
    final l10n = AppLocalizations.of(context)!;

    return GradientScaffold(
      appBar: AppTopBar(title: l10n.pos),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = ResponsiveBreakpoints.isCompact(
            constraints.maxWidth,
          );

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveBreakpoints.maxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isCompact ? 8 : 16,
                  8,
                  isCompact ? 8 : 16,
                  isCompact ? 8 : 16,
                ),
                child: isCompact
                    ? _buildCompactLayout(
                        context,
                        l10n,
                        ref,
                        cartItems,
                        selectedCustomerId,
                        subtotal,
                        total,
                        canCheckout,
                        discountWarning,
                        constraints.maxHeight,
                      )
                    : _buildWideLayout(
                        context,
                        l10n,
                        ref,
                        cartItems,
                        selectedCustomerId,
                        subtotal,
                        total,
                        canCheckout,
                        discountWarning,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Wide layout: products left, cart right (2 columns)
  Widget _buildWideLayout(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    List<CartItem> cartItems,
    String? selectedCustomerId,
    int subtotal,
    int total,
    bool canCheckout,
    String? discountWarning,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side: Product Grid (70%)
        Expanded(flex: 7, child: _buildProductSection(context, l10n, ref)),
        const SizedBox(width: 16),
        // Right Side: Cart Panel (30%)
        Expanded(
          flex: 3,
          child: _buildCartSection(
            context,
            l10n,
            ref,
            cartItems,
            selectedCustomerId,
            subtotal,
            total,
            canCheckout,
            discountWarning,
          ),
        ),
      ],
    );
  }

  // Compact layout: products and cart stacked (single column)
  Widget _buildCompactLayout(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    List<CartItem> cartItems,
    String? selectedCustomerId,
    int subtotal,
    int total,
    bool canCheckout,
    String? discountWarning,
    double availableHeight,
  ) {
    final viewportHeight = availableHeight.isFinite
        ? availableHeight
        : MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowPhone = screenWidth < 390;
    final contentHeight = viewportHeight.clamp(560.0, 980.0);
    const sectionSpacing = 12.0;
    final productHeight = (contentHeight * (isNarrowPhone ? 0.40 : 0.44)).clamp(
      240.0,
      430.0,
    );
    final cartHeight = (contentHeight - productHeight - sectionSpacing).clamp(
      280.0,
      560.0,
    );

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: contentHeight),
        child: Column(
          children: [
            SizedBox(
              height: productHeight,
              child: _buildProductSection(context, l10n, ref),
            ),
            const SizedBox(height: sectionSpacing),
            SizedBox(
              height: cartHeight,
              child: _buildCartSection(
                context,
                l10n,
                ref,
                cartItems,
                selectedCustomerId,
                subtotal,
                total,
                canCheckout,
                discountWarning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSection(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    return Column(
      children: [
        // Tab Bar for Services and Side Revenue
        AppCard(
          padding: EdgeInsets.zero,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: _lang(context, 'الخدمات', 'Services')),
              Tab(text: _lang(context, 'ربح جانبي', 'Side Revenue')),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Services Panel / Side Revenue Form
        SizedBox(
          height: _servicesPanelHeight(context),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Services tab
              ServicesPanel(
                onAddServiceItem:
                    ({
                      required category,
                      required provider,
                      required providerLabel,
                      required amountCents,
                      profitCents,
                      notes,
                      customerName,
                    }) {
                      setState(() {
                        _serviceItems.add(
                          ServiceCartItem(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            category: category,
                            provider: provider,
                            providerLabel: providerLabel,
                            amountCents: amountCents,
                            profitCents: profitCents,
                            notes: notes,
                            customerName: customerName,
                          ),
                        );
                      });
                    },
              ),
              // Side Revenue tab
              SideRevenueForm(),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Search Bar
        AppCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.search, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _lang(
                      context,
                      'بحث عن منتج او قطعة',
                      'Search product or part',
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    ref.read(posSearchQueryProvider.notifier).state = value;
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(posSearchQueryProvider.notifier).state = '';
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: AppCard(
            padding: const EdgeInsets.all(12),
            child: ref
                .watch(posSearchResultsProvider)
                .when(
                  data: (products) {
                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Theme.of(context).disabledColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _lang(
                                context,
                                'لا توجد منتجات',
                                'No products found',
                              ),
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final screenWidth = MediaQuery.of(context).size.width;
                    int crossAxisCount;
                    if (screenWidth >= 1400) {
                      crossAxisCount = 6;
                    } else if (screenWidth >= 1100) {
                      crossAxisCount = 5;
                    } else if (screenWidth >= 900) {
                      crossAxisCount = 4;
                    } else if (screenWidth >= 390) {
                      crossAxisCount = 3;
                    } else {
                      crossAxisCount = 2;
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return PosProductCard(
                          product: product,
                          onTap: () =>
                              _showProductDetails(context, ref, product),
                        );
                      },
                    );
                  },
                  error: (error, stack) => Center(
                    child: AppErrorState(
                      message: 'Failed to load products',
                      details: error.toString(),
                      stackTrace: stack,
                      onRetry: () => ref.invalidate(posSearchResultsProvider),
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartSection(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
    List<CartItem> cartItems,
    String? selectedCustomerId,
    int subtotal,
    int total,
    bool canCheckout,
    String? discountWarning,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Customer Selection with Add Button
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: AppColors.blue600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedCustomerId == null
                              ? l10n.selectCustomer
                              : l10n.customer,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  final customerId = await showDialog<String>(
                    context: context,
                    builder: (context) => AddCustomerDialog(
                      onCustomerAdded: (id) {
                        ref.invalidate(posCustomersProvider);
                      },
                    ),
                  );

                  if (customerId != null) {
                    ref.read(posSelectedCustomerIdProvider.notifier).state =
                        customerId;
                  }
                },
                icon: const Icon(Icons.person_add),
                tooltip: l10n.addCustomer,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.blue600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Active Customer Dropdown
          ref
              .watch(posCustomersProvider)
              .when(
                data: (customers) {
                  if (customers.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return DropdownButtonFormField<String>(
                    initialValue: selectedCustomerId,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      labelText: l10n.customer,
                    ),
                    items: customers.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(
                          '${c.name} (${_formatCents(c.balance)})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      ref.read(posSelectedCustomerIdProvider.notifier).state =
                          val;
                    },
                  );
                },
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Error loading customers',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
                loading: () => const LinearProgressIndicator(),
              ),
          const Divider(height: 32),
          // Cart Items
          Expanded(
            child: cartItems.isEmpty && _serviceItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 48,
                          color: Theme.of(context).dividerColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _lang(context, 'السلة فارغة', 'Cart is empty'),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _serviceItems.length + cartItems.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      if (index < _serviceItems.length) {
                        final item = _serviceItems[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${_formatCents(item.amountCents)} ${item.providerLabel}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(_lang(context, 'خدمة', 'Service')),
                          trailing: SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _serviceItems.removeAt(index);
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    _formatCents(item.amountCents),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final item = cartItems[index - _serviceItems.length];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => _showCartItemDetails(item.product),
                        title: Text(
                          item.product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${_formatCents(item.product.sellPrice)} × ${item.qty}',
                        ),
                        trailing: SizedBox(
                          width: 180,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  ref
                                      .read(posCartProvider.notifier)
                                      .decrement(item.product.id);
                                },
                              ),
                              Text(
                                '${item.qty}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  ref
                                      .read(posCartProvider.notifier)
                                      .increment(item.product.id);
                                },
                              ),
                              Expanded(
                                child: Text(
                                  _formatCents(item.lineTotal),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          // Totals & Actions - wrapped in SingleChildScrollView for small heights
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${l10n.total}:'),
                      Text(
                        _formatCents(subtotal),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${l10n.discount}:'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _discountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _discount = _parseMoneyToIlsCents(value);
                            });
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            suffixText: '₪',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (discountWarning != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          discountWarning,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.total,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatCents(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Payment Inputs
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.payment),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _paidController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onChanged: (value) {
                                setState(() {
                                  _paid = _parseMoneyToIlsCents(value);
                                });
                              },
                              decoration: const InputDecoration(
                                suffixText: '₪',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.payment),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: _paymentType,
                              items: [
                                DropdownMenuItem(
                                  value: 'Cash',
                                  child: Text(l10n.cash),
                                ),
                                DropdownMenuItem(
                                  value: 'Card',
                                  child: Text(l10n.card),
                                ),
                                DropdownMenuItem(
                                  value: 'Transfer',
                                  child: Text(l10n.transfer),
                                ),
                                DropdownMenuItem(
                                  value: 'Credit',
                                  child: Text(l10n.credit),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _paymentType = value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_paymentType != 'Credit')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_paid < total)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              _lang(
                                context,
                                'سيتم تحويل المتبقي إلى الديون بعد التأكيد',
                                'Remaining amount will be moved to debt after confirmation',
                              ),
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _lang(context, 'الباقي:', 'Remaining:'),
                              style: TextStyle(
                                color: _paid < total
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            Text(
                              _paid >= total
                                  ? _formatCents(_paid - total)
                                  : _formatCents(total - _paid),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _paid < total
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  GradientButton(
                    label: l10n.checkout,
                    icon: Icons.check_circle_outline,
                    isLoading: _isCheckingOut,
                    onPressed: canCheckout ? _checkout : null,
                  ),
                  if (_lastSaleId != null) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _lang(
                                context,
                                'اضغط زر الطباعة من أعلى شاشة المعاينة',
                                'Press the print button at the top of preview',
                              ),
                            ),
                          ),
                        );
                        _showSaleInvoicePreview(_lastSaleId!);
                      },
                      icon: const Icon(Icons.print),
                      label: Text(l10n.print),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
