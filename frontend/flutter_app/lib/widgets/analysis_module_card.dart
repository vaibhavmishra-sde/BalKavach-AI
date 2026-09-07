import 'package:flutter/material.dart';
import 'glass_card.dart';

class AnalysisModuleCard extends StatelessWidget {
  final String moduleName;
  final IconData icon;
  final String progressLabel;
  final double progressValue;
  final int confidence;
  final String riskLevel;
  final Color riskColor;

  const AnalysisModuleCard({
    required this.moduleName,
    required this.icon,
    required this.progressLabel,
    required this.progressValue,
    required this.confidence,
    required this.riskLevel,
    required this.riskColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: riskColor.withOpacity(0.2), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: riskColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(moduleName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: riskColor.withOpacity(0.16), borderRadius: BorderRadius.circular(12)),
                child: Text(riskLevel, style: TextStyle(color: riskColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(value: progressValue, backgroundColor: Colors.white12, color: riskColor),
          const SizedBox(height: 10),
          Text(progressLabel, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$confidence% confidence', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Text('History', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.history, size: 16, color: Colors.white54),
              SizedBox(width: 8),
              Expanded(child: Text('3 recent checks', style: TextStyle(color: Colors.white60, fontSize: 13))),
            ],
          ),
        ],
      ),
    );
  }
}
