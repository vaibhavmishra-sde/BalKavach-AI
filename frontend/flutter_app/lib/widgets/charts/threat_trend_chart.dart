import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ThreatTrendChart extends StatelessWidget {
  const ThreatTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 120,
        gridData: FlGridData(show: true, horizontalInterval: 20, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.white12, strokeWidth: 1)),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 20, getTitlesWidget: (value, _) => Text('${value.toInt()}', style: const TextStyle(color: Colors.white60, fontSize: 10)))),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
            const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            final index = value.toInt();
            if (index < 0 || index >= labels.length) return const SizedBox.shrink();
            return SideTitleWidget(meta: meta, child: Text(labels[index], style: const TextStyle(color: Colors.white60, fontSize: 10)));
          })),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 26),
              FlSpot(1, 55),
              FlSpot(2, 45),
              FlSpot(3, 68),
              FlSpot(4, 56),
              FlSpot(5, 74),
              FlSpot(6, 92),
            ],
            isCurved: true,
            gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF4FC3F7)]),
            barWidth: 4,
            dotData: FlDotData(
              show: true,
              getDotPainter: (_spot, _percentage, _barData, _index) => FlDotCirclePainter(
                color: Colors.white,
                radius: 3,
              ),
            ),
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [Colors.indigoAccent.withOpacity(0.28), Colors.transparent])),
          ),
        ],
      ),
    );
  }
}
