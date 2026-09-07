import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onExport;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final int notificationCount;
  final TextEditingController searchController;
  final VoidCallback onProfileSelected;

  const TopNavBar({
    required this.onExport,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.notificationCount,
    required this.searchController,
    required this.onProfileSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B4CCA), Color(0xFF7F5BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Text('BalKavach', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search threats, devices, reports...', 
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            _ActionButton(
              icon: isDarkMode ? Icons.wb_sunny : Icons.dark_mode,
              label: isDarkMode ? 'Light' : 'Dark',
              onTap: onToggleTheme,
            ),
            const SizedBox(width: 12),
            _ActionButton(icon: Icons.file_download, label: 'Export', onTap: onExport),
            const SizedBox(width: 12),
            _ActionButton(
              icon: Icons.link,
              label: 'balkavach',
              onTap: () async {
                final uri = Uri.parse('https://balkavach.app');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            const SizedBox(width: 12),
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  tooltip: 'Notifications',
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(notificationCount.toString(), style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: onProfileSelected,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(radius: 18, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, color: Colors.white)),
                    SizedBox(width: 10),
                    Text('Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextButton.icon(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
