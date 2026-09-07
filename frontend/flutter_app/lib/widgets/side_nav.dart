import 'package:flutter/material.dart';

class SideNav extends StatelessWidget {
  final bool collapsed;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onToggle;

  const SideNav({
    required this.collapsed,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.dashboard, label: 'Home'),
      _NavItem(icon: Icons.warning, label: 'Alerts'),
      _NavItem(icon: Icons.analytics, label: 'AI'),
      _NavItem(icon: Icons.settings, label: 'Settings'),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: collapsed ? 88 : 260,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF171A3C), Color(0xFF302C6C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(32), bottomRight: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 30, offset: const Offset(4, 6)),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 24, backgroundColor: Colors.white24, child: Icon(Icons.shield, color: Colors.white, size: 28)),
              if (!collapsed) ...[
                const SizedBox(width: 12),
                const Text('BalKavach', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ]
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = selectedIndex == index;
                return InkWell(
                  onTap: () => onItemSelected(index),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white12 : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, color: selected ? Colors.white : Colors.white70, size: 24),
                        if (!collapsed) ...[
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(item.label, style: TextStyle(color: selected ? Colors.white : Colors.white70, fontSize: 16, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onToggle,
            child: Row(
              mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: [
                if (!collapsed) const Text('Collapse', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                Icon(collapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: Colors.white70, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
