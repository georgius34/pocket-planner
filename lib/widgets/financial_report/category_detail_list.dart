import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryDetailList extends StatelessWidget {
  final Map<String, double> data;
  final double total;

  const CategoryDetailList({Key? key, required this.data, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the currency formatter
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green.shade900, wordSpacing: 1.5),
          ),
          const SizedBox(height: 16),
          Column(
            children: data.entries.map((entry) {
              final percentage = (entry.value / total) * 100;
              final color = Colors.primaries[data.keys.toList().indexOf(entry.key) % Colors.primaries.length];
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 30,
                          color: color,
                          child: Center(
                            child: Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          formatter.format(entry.value), // Format the value as currency
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(), // Add a divider
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
