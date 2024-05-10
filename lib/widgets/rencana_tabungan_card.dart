import 'package:flutter/material.dart';

class RencanaTabunganCard extends StatelessWidget {
  final String title;
  final double targetAmount;
  final String startDate;
  final String description;

  const RencanaTabunganCard({
    required this.title,
    required this.targetAmount,
    required this.startDate,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Target: Rp ${targetAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Start Date: $startDate',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
