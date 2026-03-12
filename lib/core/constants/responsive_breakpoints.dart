/// Responsive breakpoints for the app
class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  /// Mobile breakpoint - small phone screens
  static const double mobile = 600;

  /// Tablet breakpoint - tablet and small desktop
  static const double tablet = 900;

  /// Desktop breakpoint - normal desktop screens
  static const double desktop = 1200;

  /// Large desktop breakpoint - large screens
  static const double largeDesktop = 1600;

  /// Compact mode - sidebar collapses to icons or drawer
  static const double compact = 1100;

  /// Wide mode - full sidebar and two-column layouts
  static const double wide = 1100;

  /// Check if screen is mobile
  static bool isMobile(double width) => width < mobile;

  /// Check if screen is tablet
  static bool isTablet(double width) => width >= mobile && width < desktop;

  /// Check if screen is desktop
  static bool isDesktop(double width) => width >= desktop;

  /// Check if screen is large desktop
  static bool isLargeDesktop(double width) => width >= largeDesktop;

  /// Check if screen is compact (for sidebar)
  static bool isCompact(double width) => width < compact;

  /// Check if screen is wide
  static bool isWide(double width) => width >= wide;

  /// Get responsive columns count for grids
  static int getGridColumns(double width) {
    if (width < mobile) return 1;
    if (width < tablet) return 2;
    if (width < desktop) return 3;
    if (width < largeDesktop) return 4;
    return 6;
  }

  /// Get responsive spacing
  static double getSpacing(double width) {
    if (width < mobile) return 8;
    if (width < tablet) return 12;
    if (width < desktop) return 16;
    return 24;
  }

  /// Get responsive padding
  static double getPadding(double width) {
    if (width < mobile) return 12;
    if (width < tablet) return 16;
    if (width < desktop) return 20;
    return 24;
  }

  /// Minimum sidebar width when collapsed
  static const double sidebarCollapsed = 80;

  /// Full sidebar width when expanded
  static const double sidebarExpanded = 240;

  /// Maximum content width for centered layouts
  static const double maxContentWidth = 1400;

  /// Maximum dialog width
  static const double maxDialogWidth = 640;
}
