import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard_screen.dart';

class BalKavachApp extends StatelessWidget {
  const BalKavachApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final baseText = const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );

    return MaterialApp(
      title: 'BalKavach',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF3B4CCA),
        scaffoldBackgroundColor: const Color(0xFFF5F7FF),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF3B4CCA), elevation: 0),
        textTheme: baseText.apply(bodyColor: Colors.black87, displayColor: Colors.black87),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(secondary: Colors.cyanAccent),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFF0F132D),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF14172B), elevation: 0),
        textTheme: baseText,
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark, primarySwatch: Colors.indigo).copyWith(secondary: Colors.cyanAccent),
      ),
      debugShowCheckedModeBanner: false,
      home: const _AuthenticationGate(),
    );
  }
}

/// Keeps the visible screen in sync with the session state. When login or
/// sign-up succeeds, AuthProvider notifies listeners and this swaps the form
/// for the protected application interface immediately.
class _AuthenticationGate extends StatelessWidget {
  const _AuthenticationGate();

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: isAuthenticated
          ? const DashboardScreen(key: ValueKey('dashboard'))
          : const LoginScreen(key: ValueKey('login')),
    );
  }
}
