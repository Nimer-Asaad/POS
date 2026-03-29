import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/customers/presentation/customers_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/invoices/presentation/sales_invoices_screen.dart';
import '../features/pos/presentation/pos_screen.dart';
import '../features/inventory/presentation/daily_services_inventory_screen.dart';
import '../features/repairs/presentation/repairs_screen.dart';
import '../features/repairs/presentation/debts_screen.dart';
import '../features/repairs/presentation/suppliers_screen.dart';
import '../features/repairs/presentation/purchase_invoices_screen.dart'
    as repair_purchases;
import '../features/reports/presentation/reports_screen.dart';
import '../features/reports/presentation/transactions_history_screen.dart';
import '../features/reports/presentation/provider_operations_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'theme.dart';
import '../core/providers/settings_provider.dart';
import '../core/ui/widgets/app_scaffold.dart' as custom;
import '../l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'POS System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const ShellScreen(),
    );
  }
}

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final destinations = [
      custom.NavigationDestination(
        label: l10n.dashboard,
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
      ),
      custom.NavigationDestination(
        label: l10n.pos,
        icon: Icons.point_of_sale_outlined,
        selectedIcon: Icons.point_of_sale,
      ),
      custom.NavigationDestination(
        label: l10n.repairs,
        icon: Icons.build_outlined,
        selectedIcon: Icons.build,
      ),
      custom.NavigationDestination(
        label: 'Debts',
        icon: Icons.money_off_outlined,
        selectedIcon: Icons.money_off,
      ),
      custom.NavigationDestination(
        label: 'Suppliers',
        icon: Icons.local_shipping_outlined,
        selectedIcon: Icons.local_shipping,
      ),
      custom.NavigationDestination(
        label: 'Part Purchases',
        icon: Icons.shopping_cart_checkout_outlined,
        selectedIcon: Icons.shopping_cart_checkout,
      ),
      custom.NavigationDestination(
        label: l10n.inventory,
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
      ),
      custom.NavigationDestination(
        label: l10n.salesInvoices,
        icon: Icons.receipt_outlined,
        selectedIcon: Icons.receipt,
      ),
      custom.NavigationDestination(
        label: 'Service Inventory',
        icon: Icons.calculate_outlined,
        selectedIcon: Icons.calculate,
      ),
      custom.NavigationDestination(
        label: l10n.customers,
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
      ),
      custom.NavigationDestination(
        label: l10n.reports,
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart,
      ),
      custom.NavigationDestination(
        label: Localizations.localeOf(context).languageCode == 'ar'
            ? 'سجل المعاملات'
            : 'Transactions',
        icon: Icons.history_outlined,
        selectedIcon: Icons.history,
      ),
      custom.NavigationDestination(
        label: Localizations.localeOf(context).languageCode == 'ar'
            ? 'عمليات المزودات'
            : 'Provider Operations',
        icon: Icons.swap_horiz_outlined,
        selectedIcon: Icons.swap_horiz,
      ),
      custom.NavigationDestination(
        label: l10n.settings,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
      ),
    ];

    final screens = [
      DashboardScreen(
        onNavigate: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      const PosScreen(),
      const RepairsScreen(),
      const DebtsScreen(),
      const SuppliersScreen(),
      const repair_purchases.PurchaseInvoicesScreen(),
      const InventoryScreen(),
      const SalesInvoicesScreen(),
      const DailyServicesInventoryScreen(),
      const CustomersScreen(),
      const ReportsScreen(),
      const TransactionsHistoryScreen(),
      const ProviderOperationsScreen(),
      const SettingsScreen(),
    ];

    return custom.AppScaffold(
      selectedIndex: _index,
      destinations: destinations,
      body: screens[_index],
      onDestinationSelected: (index) {
        setState(() {
          _index = index;
        });
      },
    );
  }
}
