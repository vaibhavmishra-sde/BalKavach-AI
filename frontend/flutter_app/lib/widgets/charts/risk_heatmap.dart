import 'package:flutter/material.dart';

class RiskHeatmap extends StatelessWidget {
  const RiskHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      [Colors.greenAccent, Colors.greenAccent, Colors.yellowAccent, Colors.orangeAccent],
      [Colors.greenAccent, Colors.yellowAccent, Colors.orangeAccent, Colors.redAccent],
      [Colors.yellowAccent, Colors.orangeAccent, Colors.redAccent, Colors.redAccent],
      [Colors.orangeAccent, Colors.redAccent, Colors.redAccent, Colors.deepPurpleAccent],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...rows.map((row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: row
                    .map((color) => Expanded(
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(color: color.withOpacity(0.92), borderRadius: BorderRadius.circular(12)),
                          ),
                        ))
                    .toList(),
              ),
            )),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Low', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('Critical', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        )
      ],
    );
  }
}
