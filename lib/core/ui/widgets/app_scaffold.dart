import 'package:flutter/material.dart';

import '../../../core/constants/responsive_breakpoints.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_radius.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_text_styles.dart';
import 'app_header.dart';

class AppScaffold extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final Widget body;
  final ValueChanged<int> onDestinationSelected;
  final String? pageTitle;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.body,
    required this.onDestinationSelected,
    this.pageTitle,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return LayoutBuilder(
      builder: (context, constraints) {
        // In landscape mode (app default), always show sidebar
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        final isCompact = ResponsiveBreakpoints.isCompact(constraints.maxWidth);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          floatingActionButton: floatingActionButton,
          drawer: !isLandscape ? _buildDrawer(context, isDark) : null,
          body: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.appBackgroundDark
                  : AppColors.appBackground,
            ),
            child: Row(
              children: [
                // Left Sidebar (NavigationRail) - always visible in landscape
                if (isLandscape) _buildNavigationRail(context, isDark, isRTL),

                // Main Content Area
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(context, isDark, !isLandscape),

                      // Page Content
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(
                            isCompact ? AppSpacing.sm : AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.gray200,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            child: body,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isCompact) {
    if (isCompact) {
      // Add menu button for compact mode
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.gray200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Builder(
              builder: (scaffoldContext) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(scaffoldContext).openDrawer();
                },
              ),
            ),
            const Expanded(child: AppHeader()),
          ],
        ),
      );
    }
    return const AppHeader();
  }

  Widget _buildDrawer(BuildContext context, bool isDark) {
    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDark ? Theme.of(context).scaffoldBackgroundColor : AppColors.blue600,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shop, size: 48, color: Theme.of(context).colorScheme.onPrimary),
                  const SizedBox(height: 8),
                  Text(
                    'POS System',
                    style: AppTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...destinations.asMap().entries.map((entry) {
              final index = entry.key;
              final dest = entry.value;
              final isSelected = selectedIndex == index;

              return ListTile(
                leading: Icon(
                  isSelected ? dest.selectedIcon : dest.icon,
                  color: isSelected
                      ? AppColors.blue600
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.gray500),
                ),
                title: Text(
                  dest.label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.blue600
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.gray700),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                selectedTileColor: isDark
                    ? AppColors.blue600.withOpacity(0.1)
                    : AppColors.blue50,
                onTap: () {
                  onDestinationSelected(index);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context, bool isDark, bool isRTL) {
    return Container(
      width: ResponsiveBreakpoints.sidebarCollapsed,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: !isRTL
              ? BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.gray200,
                  width: 1,
                )
              : BorderSide.none,
          left: isRTL
              ? BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.gray200,
                  width: 1,
                )
              : BorderSide.none,
        ),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              backgroundColor: Colors.transparent,
              indicatorColor: isDark
                  ? AppColors.blue600.withOpacity(0.2)
                  : AppColors.blue50,
              selectedIconTheme: IconThemeData(
                color: isDark ? AppColors.blue600 : AppColors.blue600,
              ),
              unselectedIconTheme: IconThemeData(
                color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
              ),
              selectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
                color: isDark ? AppColors.blue600 : AppColors.blue600,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
              ),
              labelType: NavigationRailLabelType.all,
              destinations: destinations
                  .map(
                    (dest) => NavigationRailDestination(
                      icon: Icon(dest.icon),
                      selectedIcon: Icon(dest.selectedIcon),
                      label: Text(
                        dest.label,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const NavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}
