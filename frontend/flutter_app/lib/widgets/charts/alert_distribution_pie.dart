import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AlertDistributionPie extends StatelessWidget {
  const AlertDistributionPie({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 42, color: Colors.redAccent, title: 'High', radius: 56, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          PieChartSectionData(value: 32, color: Colors.orangeAccent, title: 'Medium', radius: 48, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          PieChartSectionData(value: 26, color: Colors.greenAccent, title: 'Low', radius: 40, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
        centerSpaceRadius: 32,
        sectionsSpace: 6,
      ),
    );
  }
}
