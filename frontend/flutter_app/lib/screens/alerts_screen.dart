import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alert Center', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Review all threats, action status, and alert history from a centralized control panel.', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 22),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Alert Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _statusChip('Critical', Colors.redAccent),
                const SizedBox(height: 10),
                _statusChip('Investigating', Colors.orangeAccent),
                const SizedBox(height: 10),
                _statusChip('Resolved', Colors.greenAccent),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: const [
              _AlertCard(title: 'SOS Alert', subtitle: 'Emergency button pressed by child', time: '2m ago', badge: 'High'),
              _AlertCard(title: 'Toxic Chat', subtitle: 'Potential cyberbullying detected', time: '30m ago', badge: 'Medium'),
              _AlertCard(title: 'Location Update', subtitle: 'Child location shared successfully', time: '1h ago', badge: 'Low'),
              _AlertCard(title: 'Suspicious App', subtitle: 'New app installed during restricted hours', time: '3h ago', badge: 'High'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.18), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String badge;

  const _AlertCard({required this.title, required this.subtitle, required this.time, required this.badge, super.key});

  @override
  Widget build(BuildContext context) {
    final badgeColor = badge == 'High' ? Colors.redAccent : badge == 'Medium' ? Colors.orangeAccent : Colors.greenAccent;
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Colors.white70, height: 1.4)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: badgeColor.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                child: Text(badge, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Text(time, style: const TextStyle(color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }
}
