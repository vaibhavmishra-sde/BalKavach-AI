import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _filter = 'All';
  final _filters = const ['All', 'High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    final alerts = const [
      _AlertData('SOS Alert', 'Emergency button pressed by child', '2m ago', 'High'),
      _AlertData('Toxic Chat', 'Potential cyberbullying detected', '30m ago', 'Medium'),
      _AlertData('Location Update', 'Child location shared successfully', '1h ago', 'Low'),
      _AlertData('Suspicious App', 'New app installed during restricted hours', '3h ago', 'High'),
    ].where((alert) => _filter == 'All' || alert.badge == _filter).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alert Center', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Review all threats, action status, and alert history from a centralized control panel.', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 22),
          Wrap(spacing: 8, children: _filters.map((filter) => ChoiceChip(label: Text(filter), selected: _filter == filter, onSelected: (_) => setState(() => _filter = filter))).toList()),
          const SizedBox(height: 18),
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
          Column(children: alerts.map((alert) => _AlertCard(data: alert)).toList()),
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

class _AlertData {
  final String title, subtitle, time, badge;
  const _AlertData(this.title, this.subtitle, this.time, this.badge);
}

class _AlertCard extends StatelessWidget {
  final _AlertData data;

  const _AlertCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final badgeColor = data.badge == 'High' ? Colors.redAccent : data.badge == 'Medium' ? Colors.orangeAccent : Colors.greenAccent;
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(data.subtitle, style: const TextStyle(color: Colors.white70, height: 1.4)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: badgeColor.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                child: Text(data.badge, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Text(data.time, style: const TextStyle(color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }
}
