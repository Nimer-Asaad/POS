import 'package:flutter/material.dart';

import '../../constants/responsive_breakpoints.dart';

/// A dialog that adapts its size based on screen size
class ResponsiveDialog extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final double? maxHeight;

  const ResponsiveDialog({
    super.key,
    required this.child,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate responsive width and height
    double dialogWidth;
    double dialogHeight;

    if (ResponsiveBreakpoints.isMobile(screenWidth)) {
      // Mobile: Use 95% of screen
      dialogWidth = screenWidth < 390 ? screenWidth * 0.97 : screenWidth * 0.95;
      dialogHeight = screenHeight * 0.9;
    } else if (ResponsiveBreakpoints.isTablet(screenWidth)) {
      // Tablet: Use 85% of screen
      dialogWidth = screenWidth * 0.85;
      dialogHeight = screenHeight * 0.85;
    } else {
      // Desktop: Use 80% or maxWidth
      dialogWidth = screenWidth * 0.8;
      dialogHeight = screenHeight * 0.8;
    }

    // Apply max constraints if provided
    if (maxWidth != null && dialogWidth > maxWidth!) {
      dialogWidth = maxWidth!;
    }
    if (maxHeight != null && dialogHeight > maxHeight!) {
      dialogHeight = maxHeight!;
    }

    final minHeight = ResponsiveBreakpoints.isMobile(screenWidth)
        ? 220.0
        : 360.0;

    // Ensure minimum size for usability without overflowing short screens
    dialogWidth = dialogWidth.clamp(280.0, screenWidth);
    dialogHeight = dialogHeight.clamp(minHeight, screenHeight);

    return Dialog(
      child: SizedBox(width: dialogWidth, height: dialogHeight, child: child),
    );
  }
}

/// Shows a responsive dialog
Future<T?> showResponsiveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  return showDialog<T>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}
