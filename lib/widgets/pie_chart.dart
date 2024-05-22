import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample extends StatelessWidget {
  final Map<String, double> data;

  const PieChartSample({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total amount
    double total = data.values.fold(0, (sum, item) => sum + item);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: data.entries
                      .map((e) {
                        final percentage = (e.value / total) * 100;
                        return PieChartSectionData(
                          color: Colors.primaries[data.keys.toList().indexOf(e.key) % Colors.primaries.length],
                          value: e.value,
                          title: '${percentage.toStringAsFixed(1)}%',
                          radius: 50,
                          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        );
                      })
                      .toList(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
