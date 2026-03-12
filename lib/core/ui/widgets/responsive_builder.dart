import 'package:flutter/material.dart';

import '../../constants/responsive_breakpoints.dart';

/// A widget builder that adapts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  desktop;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  largeDesktop;

  const ResponsiveBuilder({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (ResponsiveBreakpoints.isLargeDesktop(width) &&
            largeDesktop != null) {
          return largeDesktop!(context, constraints);
        }

        if (ResponsiveBreakpoints.isDesktop(width) && desktop != null) {
          return desktop!(context, constraints);
        }

        if (ResponsiveBreakpoints.isTablet(width) && tablet != null) {
          return tablet!(context, constraints);
        }

        if (mobile != null) {
          return mobile!(context, constraints);
        }

        // Fallback: try desktop, then tablet, then show empty container
        if (desktop != null) return desktop!(context, constraints);
        if (tablet != null) return tablet!(context, constraints);

        return const SizedBox.shrink();
      },
    );
  }
}

/// Extension on BuildContext for responsive utilities
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => ResponsiveBreakpoints.isMobile(screenWidth);
  bool get isTablet => ResponsiveBreakpoints.isTablet(screenWidth);
  bool get isDesktop => ResponsiveBreakpoints.isDesktop(screenWidth);
  bool get isLargeDesktop => ResponsiveBreakpoints.isLargeDesktop(screenWidth);

  int get gridColumns => ResponsiveBreakpoints.getGridColumns(screenWidth);
  double get responsiveSpacing => ResponsiveBreakpoints.getSpacing(screenWidth);
  double get responsivePadding => ResponsiveBreakpoints.getPadding(screenWidth);
}

/// Responsive layout that shows different widgets based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (ResponsiveBreakpoints.isDesktop(width) && desktop != null) {
          return desktop!;
        }

        if (ResponsiveBreakpoints.isTablet(width) && tablet != null) {
          return tablet!;
        }

        return mobile;
      },
    );
  }
}
