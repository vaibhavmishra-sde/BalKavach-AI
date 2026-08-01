import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard_screen.dart';

class BalKavachApp extends StatelessWidget {
  const BalKavachApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      title: 'BalKavach',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.indigoAccent,
          secondary: Colors.cyanAccent,
        ),
      ),
      home: authProvider.isAuthenticated ? const DashboardScreen() : const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
