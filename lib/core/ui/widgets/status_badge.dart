import 'package:flutter/material.dart';

import '../../../design/app_colors.dart';
import '../../../design/app_radius.dart';
import '../../../design/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isOutlined;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isOutlined = false,
  });

  factory StatusBadge.success({required String label, IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.green50,
      textColor: AppColors.green600,
      icon: icon,
    );
  }

  factory StatusBadge.warning({required String label, IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.yellow50,
      textColor: AppColors.yellow600,
      icon: icon,
    );
  }

  factory StatusBadge.error({required String label, IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.red50,
      textColor: AppColors.red600,
      icon: icon,
    );
  }

  factory StatusBadge.info({required String label, IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppColors.blue50,
      textColor: AppColors.blue600,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveBackgroundColor =
        backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.gray100);
    final effectiveTextColor =
        textColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.gray700);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : effectiveBackgroundColor,
        border: isOutlined
            ? Border.all(color: effectiveTextColor, width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: effectiveTextColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: effectiveTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
