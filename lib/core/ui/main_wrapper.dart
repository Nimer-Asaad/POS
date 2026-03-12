import 'package:flutter/material.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/customers/presentation/customers_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';
import '../../features/pos/presentation/pos_screen.dart';
import '../../features/repairs/presentation/repairs_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import 'package:pos_store/l10n/app_localizations.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  void _handleNavigate(int index) {
    final mappedIndex = switch (index) {
      2 => 7,
      3 => 2,
      _ => index,
    };
    setState(() {
      _selectedIndex = mappedIndex;
    });
  }

  List<Widget> get _screens => [
    DashboardScreen(onNavigate: _handleNavigate),
    const PosScreen(),
    const InventoryScreen(),
    Center(child: Text(AppLocalizations.of(context)!.sales)), // Sales Invoices Placeholder
    Center(child: Text(AppLocalizations.of(context)!.invoices)), // Purchase Invoices Placeholder
    const ReportsScreen(),
    const CustomersScreen(),
    const RepairsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              // Logo / Title
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  Text(
                    'Smart POS & Inventory Management',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 48),
              
              // Navigation Tabs
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTab(0, l10n.dashboard, Icons.dashboard),
                      _buildTab(1, l10n.pos, Icons.point_of_sale),
                      _buildTab(2, l10n.products, Icons.inventory_2),
                      _buildTab(3, l10n.sales, Icons.receipt_long),
                      _buildTab(4, l10n.invoices, Icons.shopping_cart),
                      _buildTab(5, l10n.reports, Icons.bar_chart),
                      _buildTab(6, l10n.customers, Icons.people),
                      _buildTab(7, l10n.repairs, Icons.build),
                      _buildTab(8, l10n.settings, Icons.settings),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              // User Profile / Settings (Optional)
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label, IconData icon) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).textTheme.bodySmall?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
