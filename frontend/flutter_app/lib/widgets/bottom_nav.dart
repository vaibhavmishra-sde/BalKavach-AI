import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({required this.currentIndex, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Alerts'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'AI'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      selectedItemColor: Colors.cyanAccent,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
    );
  }
}
