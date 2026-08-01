import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/bottom_nav.dart';
import 'alerts_screen.dart';
import 'ai_analysis_screen.dart';
import 'settings_screen.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final _tabs = const [
    _DashboardTab(),
    AlertsScreen(),
    AiAnalysisScreen(),
    SettingsScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('BalKavach Dashboard'),
        actions: [
          IconButton(
            onPressed: auth.logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNav(currentIndex: _selectedIndex, onTap: _onTap),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Child Activity Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          const Text('Monitor screen time, recent alerts, and safety scores in one dashboard.'),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(child: _MiniCard(title: 'Screen Time', value: '4h 20m')),
              SizedBox(width: 12),
              Expanded(child: _MiniCard(title: 'Threat Reports', value: '3')),
            ],
          ),
          const SizedBox(height: 16),
          const _OverviewCard(),
          const SizedBox(height: 16),
          const Text('Safety Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: 0.78, backgroundColor: Colors.white12, color: Colors.cyanAccent),
          const SizedBox(height: 8),
          const Text('78% safe based on recent activity and alerts.'),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String title;
  final String value;

  const _MiniCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigoAccent.withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('AI Threat Detection Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('- 2 abusive messages flagged in real time'),
          Text('- 1 unsafe image detected'),
          Text('- 95% compliance with safety policies'),
        ],
      ),
    );
  }
}
