import 'package:flutter/material.dart';

import '../../../design/app_colors.dart';
import '../../../design/app_radius.dart';
import '../../../design/app_text_styles.dart';

class AppTableHeader extends StatelessWidget {
  final List<String> headers;
  final List<double>? flexValues;
  final EdgeInsetsGeometry? padding;

  const AppTableHeader({
    super.key,
    required this.headers,
    this.flexValues,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.gray50,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.gray200,
          ),
        ),
      ),
      child: Row(
        children: List.generate(headers.length, (index) {
          final flex = (flexValues != null && flexValues!.length > index)
              ? flexValues![index].toInt()
              : 1;

          return Expanded(
            flex: flex,
            child: Text(
              headers[index],
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }
}
