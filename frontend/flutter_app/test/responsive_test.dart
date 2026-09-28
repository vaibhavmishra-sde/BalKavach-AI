import 'package:flutter_test/flutter_test.dart';
import 'package:balkavach/utils/responsive.dart';

void main() {
  test('responsive breakpoints keep tablet between mobile and desktop', () {
    expect(Responsive.isMobile(759), isTrue);
    expect(Responsive.isTablet(760), isTrue);
    expect(Responsive.isTablet(1099), isTrue);
    expect(Responsive.isDesktop(1100), isTrue);
  });
}
