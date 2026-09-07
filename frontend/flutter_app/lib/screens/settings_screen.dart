import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Customize your platform preferences, notification rules, and security options.', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Enable immersive cybersecurity interface'),
                  value: themeProvider.isDarkMode,
                  activeColor: const Color(0xFF7F5BFF),
                  onChanged: (_) => themeProvider.toggleMode(),
                ),
                const Divider(color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.cyanAccent),
                  title: const Text('Alert Preferences'),
                  subtitle: const Text('Manage email, push and SMS notifications'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white60),
                  onTap: () {},
                ),
                const Divider(color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.security, color: Colors.orangeAccent),
                  title: const Text('Privacy Controls'),
                  subtitle: const Text('Adjust child monitoring settings and permissions'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white60),
                  onTap: () {},
                ),
                const Divider(color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.deepPurpleAccent),
                  title: const Text('Account Settings'),
                  subtitle: const Text('Update profile, password and access roles'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white60),
                  onTap: () {},
                ),
                const Divider(color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.lightBlueAccent),
                  title: const Text('Support Center'),
                  subtitle: const Text('Get help with the BalKavach platform'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white60),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ListTile(
                  leading: Icon(Icons.notifications_active, color: Colors.greenAccent),
                  title: Text('Notification Center'),
                  subtitle: Text('View all alert delivery and dispatch history'),
                ),
                Divider(color: Colors.white12),
                ListTile(
                  leading: Icon(Icons.file_download, color: Colors.amberAccent),
                  title: Text('Export Reports'),
                  subtitle: Text('Download weekly safety reports and threat summaries'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
