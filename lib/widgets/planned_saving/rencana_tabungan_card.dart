import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/format.dart';

class RencanaTabunganCard extends StatelessWidget {
  final dynamic rencanaData;

  const RencanaTabunganCard({required this.rencanaData});

  @override
  Widget build(BuildContext context) {
    final String title = rencanaData['title'];
    final String description = rencanaData['description'];
    final int progress = rencanaData['progress'];
    final int endDateEpoch = rencanaData['endDate']; // Milliseconds since epoch

    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endDateEpoch);

    // Calculate the number of days remaining until the end date
    DateTime today = DateTime.now();
    int daysRemaining = endDate.difference(today).inDays;

    final NumberFormat formattedTargetAmount = getCurrencyFormatter();
    String formattedAmount = formattedTargetAmount.format(rencanaData['targetAmount']);


    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    formattedAmount,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '$daysRemaining days remaining',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '$description',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: progress / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    Text(
                      '${(progress).toInt()}%',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}