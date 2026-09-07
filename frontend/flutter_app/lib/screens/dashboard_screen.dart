import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/responsive.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/glass_card.dart';
import '../widgets/side_nav.dart';
import '../widgets/top_nav.dart';
import 'ai_analysis_screen.dart';
import 'alerts_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  var _selectedIndex = 0;
  var _sidebarCollapsed = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14172B),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Account profile', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Log out', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(MediaQuery.sizeOf(context).width);
    final tabs = [
      _HomeDashboard(onOpenTab: (index) => setState(() => _selectedIndex = index)),
      const AlertsScreen(),
      const AiAnalysisScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: TopNavBar(
          isDarkMode: context.watch<ThemeProvider>().isDarkMode,
          notificationCount: 5,
          searchController: _searchController,
          onToggleTheme: context.read<ThemeProvider>().toggleMode,
          onProfileSelected: _showProfileOptions,
          onExport: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Safety report export is ready to download.')),
          ),
        ),
      ),
      body: Row(
        children: [
          if (isDesktop)
            SideNav(
              collapsed: _sidebarCollapsed,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
              onToggle: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Padding(
                key: ValueKey(_selectedIndex),
                padding: const EdgeInsets.all(16),
                child: tabs[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNav(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  final ValueChanged<int> onOpenTab;

  const _HomeDashboard({required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = width >= 900 ? 270.0 : width >= 600 ? 230.0 : width - 32;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Safety overview', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Monitor child safety, investigate alerts, and run AI checks from one place.'),
          const SizedBox(height: 20),
          GlassCard(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 620;
                final details = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current safety status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Elevated attention is recommended. Two recent conversations need review.'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => onOpenTab(1),
                      icon: const Icon(Icons.warning_amber_rounded),
                      label: const Text('Review alerts'),
                    ),
                  ],
                );
                final score = _RiskScore();
                return compact
                    ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [details, const SizedBox(height: 20), Center(child: score)])
                    : Row(children: [Expanded(child: details), const SizedBox(width: 24), score]);
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text('Quick actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _FeatureCard(width: cardWidth, icon: Icons.warning_amber_rounded, color: Colors.redAccent, title: 'Alert center', detail: 'Review 5 unresolved alerts and take action.', onTap: () => onOpenTab(1)),
              _FeatureCard(width: cardWidth, icon: Icons.psychology_alt, color: Colors.cyanAccent, title: 'AI analysis', detail: 'Scan suspicious text and images securely.', onTap: () => onOpenTab(2)),
              _FeatureCard(width: cardWidth, icon: Icons.family_restroom, color: Colors.greenAccent, title: 'Child activity', detail: 'View device activity, screen time, and app usage.', onTap: () => _showDetail(context, 'Child activity', 'Today: 12 sessions, 5h 20m screen time, and 3 monitored applications. Location sharing and live device sync can be connected when child devices are enrolled.')),
              _FeatureCard(width: cardWidth, icon: Icons.assessment, color: Colors.orangeAccent, title: 'Weekly report', detail: 'Open a summary of this week’s safety signals.', onTap: () => _showDetail(context, 'Weekly safety report', 'Messages analyzed: 12,840\nImages scanned: 4,806\nHigh-risk alerts: 8\nRecommended action: review flagged conversations with your child.')),
              _FeatureCard(width: cardWidth, icon: Icons.tune, color: Colors.deepPurpleAccent, title: 'Safety settings', detail: 'Control notifications and account preferences.', onTap: () => onOpenTab(3)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Recent activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              children: const [
                _ActivityRow(icon: Icons.chat_bubble_outline, title: 'Potential toxic message detected', subtitle: 'Conversation analysis is ready for review', color: Colors.orangeAccent),
                Divider(color: Colors.white12),
                _ActivityRow(icon: Icons.image_search, title: 'Image safety scan completed', subtitle: 'No unsafe content found', color: Colors.greenAccent),
                Divider(color: Colors.white12),
                _ActivityRow(icon: Icons.notifications_active, title: 'Guardian notification sent', subtitle: 'Alert preferences were applied successfully', color: Colors.lightBlueAccent),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, String title, String details) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(details),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}

class _RiskScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 132,
        height: 132,
        alignment: Alignment.center,
        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFFFF7043), Color(0xFFD84315)])),
        child: const Column(mainAxisSize: MainAxisSize.min, children: [Text('68%', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), Text('Risk score')]),
      );
}

class _FeatureCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final VoidCallback onTap;

  const _FeatureCard({required this.width, required this.icon, required this.color, required this.title, required this.detail, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: GlassCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 14),
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(detail, style: const TextStyle(color: Colors.white70, height: 1.35)),
              const SizedBox(height: 14),
              Text('Open', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
      );
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ActivityRow({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(backgroundColor: color.withOpacity(.18), child: Icon(icon, color: color)),
        title: Text(title),
        subtitle: Text(subtitle),
      );
}
