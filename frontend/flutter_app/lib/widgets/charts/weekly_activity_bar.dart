import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyActivityBar extends StatelessWidget {
  const WeeklyActivityBar({super.key});

  @override
  Widget build(BuildContext context) {
    final barGroups = [
      _makeGroupData(0, 8),
      _makeGroupData(1, 10),
      _makeGroupData(2, 7),
      _makeGroupData(3, 11),
      _makeGroupData(4, 9),
      _makeGroupData(5, 12),
      _makeGroupData(6, 6),
    ];
    return BarChart(
      BarChartData(
        maxY: 14,
        barGroups: barGroups,
        gridData: FlGridData(show: true, drawHorizontalLine: true, horizontalInterval: 2, getDrawingHorizontalLine: (value) => FlLine(color: Colors.white12, strokeWidth: 1)),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
            const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
            final index = value.toInt();
            if (index < 0 || index >= labels.length) return const SizedBox.shrink();
            return SideTitleWidget(meta: meta, child: Text(labels[index], style: const TextStyle(color: Colors.white60, fontSize: 12)));
          })),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: const Color(0xFF7F5BFF), width: 18, borderRadius: BorderRadius.circular(12)),
      ],
    );
  }
}
