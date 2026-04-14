import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/widgets/app_card.dart';
import '../../../core/ui/widgets/app_section_title.dart';
import '../../../core/ui/widgets/app_error_state.dart';
import '../../../core/constants/responsive_breakpoints.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_radius.dart';
import '../../../design/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  final void Function(int index) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Watch dashboard data from provider
    final dashboardDataAsync = ref.watch(dashboardDataProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.dashboard_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dashboard,
                        style: AppTextStyles.h2.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.dashboardSubtitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // KPIs Section Title
          AppSectionTitle(
            title: isRTL ? 'نظرة عامة' : 'Overview',
            subtitle: isRTL ? 'إحصائيات اليوم' : 'Today\'s Statistics',
          ),

          const SizedBox(height: AppSpacing.md),

          // KPI Cards Grid with Loading State
          dashboardDataAsync.when(
            data: (data) => _buildKpiGrid(context, data, isDark, isRTL),
            loading: () => _buildLoadingGrid(context),
            error: (error, stack) => AppErrorState(
              message: 'Unable to load dashboard data',
              details: error.toString(),
              stackTrace: stack,
              onRetry: () => ref.invalidate(dashboardDataProvider),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Quick Actions Section
          AppSectionTitle(
            title: l10n.quickActions,
            subtitle: isRTL
                ? 'إجراءات سريعة للوصول السريع'
                : 'Quick access actions',
          ),

          const SizedBox(height: AppSpacing.md),

          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate button width based on available space
                final spacing = AppSpacing.md;
                final availableWidth = constraints.maxWidth;
                int buttonsPerRow = 4;
                if (ResponsiveBreakpoints.isMobile(availableWidth)) {
                  buttonsPerRow = 1;
                } else if (ResponsiveBreakpoints.isTablet(availableWidth)) {
                  buttonsPerRow = 2;
                }
                final buttonWidth =
                    (availableWidth - (spacing * (buttonsPerRow - 1))) /
                    buttonsPerRow;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _QuickActionButton(
                      label: l10n.newSale,
                      icon: Icons.point_of_sale,
                      gradient: AppColors.primaryGradient,
                      onTap: () => onNavigate(1), // Navigate to POS
                      isDark: isDark,
                      width: buttonWidth.clamp(180, 280),
                    ),
                    _QuickActionButton(
                      label: l10n.newRepair,
                      icon: Icons.build_circle_outlined,
                      gradient: AppColors.warningGradient,
                      onTap: () => onNavigate(2), // Navigate to Repairs
                      isDark: isDark,
                      width: buttonWidth.clamp(180, 280),
                    ),
                    _QuickActionButton(
                      label: l10n.addProduct,
                      icon: Icons.add_box_outlined,
                      gradient: AppColors.successGradient,
                      onTap: () => onNavigate(6), // Navigate to Inventory
                      isDark: isDark,
                      width: buttonWidth.clamp(180, 280),
                    ),
                    _QuickActionButton(
                      label: isRTL ? 'الجرد' : 'Service Inventory',
                      icon: Icons.calculate_outlined,
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade600, Colors.cyan.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () =>
                          onNavigate(8), // Navigate to Service Inventory
                      isDark: isDark,
                      width: buttonWidth.clamp(180, 280),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(
    BuildContext context,
    DashboardData data,
    bool isDark,
    bool isRTL,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns = ResponsiveBreakpoints.getGridColumns(width);
        // For KPIs, max 4 columns
        if (columns > 4) columns = 4;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.4,
          children: [
            _KpiCard(
              title: isRTL ? 'مبيعات اليوم' : 'Today\'s Orders',
              value: data.todayOrdersCount.toString(),
              subtitle: isRTL ? 'عدد الفواتير' : 'Invoices',
              icon: Icons.receipt_long,
              gradient: AppColors.primaryGradient,
              isDark: isDark,
              onTap: () => onNavigate(4), // Navigate to Sales/Reports
            ),
            _KpiCard(
              title: isRTL ? 'الأرباح الإجمالية' : 'Total Profit',
              value: '${data.totalProfit.toStringAsFixed(2)} ₪',
              subtitle: isRTL
                  ? 'مبيعات + خدمات + جانبي + صيانة'
                  : 'Sales + Services + Side + Repair',
              icon: Icons.trending_up,
              gradient: AppColors.successGradient,
              isDark: isDark,
              onTap: () => onNavigate(4), // Navigate to Sales/Reports
            ),
            _KpiCard(
              title: isRTL ? 'أجهزة الصيانة' : 'Repair Devices',
              value: data.todayRepairsCount.toString(),
              subtitle: isRTL ? 'تحت الإصلاح' : 'Active',
              icon: Icons.build_circle,
              gradient: AppColors.warningGradient,
              isDark: isDark,
              onTap: () => onNavigate(2), // Navigate to Repairs
            ),
            _KpiCard(
              title: isRTL ? 'أرباح الصيانة' : 'Repair Profit',
              value: '${data.todayRepairsProfit.toStringAsFixed(2)} ₪',
              subtitle: isRTL ? 'تكاليف العمل' : 'Labor Cost',
              icon: Icons.monetization_on,
              gradient: LinearGradient(
                colors: [AppColors.indigo600, AppColors.purple600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              isDark: isDark,
              onTap: () => onNavigate(2), // Navigate to Repairs
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns = 4;
        if (width < 600) {
          columns = 1;
        } else if (width < 900) {
          columns = 2;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.4,
          children: List.generate(
            4,
            (_) => AppCard(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue600),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// KPI Card Widget
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final bool isDark;
  final VoidCallback? onTap;

  const _KpiCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.gradient,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 4, color: gradient.colors.first),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        boxShadow: [
                          BoxShadow(
                            color: gradient.colors.first.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  value,
                  style: AppTextStyles.h2.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Quick Action Button Widget
class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final bool isDark;
  final double width;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.isDark,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.gray50,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.gray200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
