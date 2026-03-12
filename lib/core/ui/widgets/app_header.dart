import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/app_colors.dart';
import '../../../design/app_radius.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'status_badge.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = settings.locale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // App Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'نظام نقطة البيع' : 'POS System',
                  style: AppTextStyles.h3.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isArabic
                      ? 'إدارة متكاملة للمبيعات والمخزون'
                      : 'Complete Sales & Inventory Management',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Status Badges
          StatusBadge.success(
            label: isArabic ? 'متصل' : 'Online',
            icon: Icons.check_circle,
          ),

          const SizedBox(width: 8),

          StatusBadge.info(
            label: isArabic ? 'المتجر الرئيسي' : 'Main Store',
            icon: Icons.store,
          ),

          const SizedBox(width: 16),

          // Language Toggle
          _buildIconButton(
            context: context,
            icon: Icons.language,
            tooltip: l10n.language,
            onPressed: () => _showLanguageMenu(context, ref),
          ),

          const SizedBox(width: 8),

          // Theme Toggle
          _buildIconButton(
            context: context,
            icon: isDark ? Icons.light_mode : Icons.dark_mode,
            tooltip: l10n.theme,
            onPressed: () => _toggleTheme(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.gray100,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _toggleTheme(WidgetRef ref) {
    final currentTheme = ref.read(settingsProvider).themeMode;
    final newTheme = currentTheme == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    ref.read(settingsProvider.notifier).setThemeMode(newTheme);
  }

  void _showLanguageMenu(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.read(settingsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.arabic),
              value: 'ar',
              groupValue: settings.locale.languageCode,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: settings.locale.languageCode,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}
