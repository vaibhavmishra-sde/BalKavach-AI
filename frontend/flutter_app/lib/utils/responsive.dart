class Responsive {
  static bool isDesktop(double width) => width >= 1100;
  static bool isTablet(double width) => width >= 760 && width < 1100;
  static bool isMobile(double width) => width < 760;
}
