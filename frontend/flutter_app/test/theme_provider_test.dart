import 'package:flutter_test/flutter_test.dart';
import 'package:balkavach/providers/theme_provider.dart';

void main() {
  test('theme provider starts in dark mode', () {
    final provider = ThemeProvider();
    expect(provider.isDarkMode, isTrue);
    expect(provider.themeMode, ThemeMode.dark);
  });

  test('theme provider toggles and accepts explicit mode', () {
    final provider = ThemeProvider();
    provider.toggleMode();
    expect(provider.themeMode, ThemeMode.light);
    provider.setMode(true);
    expect(provider.themeMode, ThemeMode.dark);
  });
}
