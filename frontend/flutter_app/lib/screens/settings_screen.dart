import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Manage push notification preferences'),
          ),
          ListTile(
            leading: Icon(Icons.shield),
            title: Text('Privacy'),
            subtitle: Text('Configure child activity protection'),
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Support'),
            subtitle: Text('Contact support and learn more'),
          ),
        ],
      ),
    );
  }
}
