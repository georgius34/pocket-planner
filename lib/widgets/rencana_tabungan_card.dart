  import 'package:flutter/material.dart';
  import 'package:flutter/widgets.dart';

class RencanaTabunganCard extends StatelessWidget {
  final String title;
  final double targetAmount;
  final double currentAmount;
  final int deadline;
  final String description;
  final double progress; // Add progress as a parameter

  const RencanaTabunganCard({
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.description,
    required this.deadline,
    required this.progress, // Initialize progress
  });

  @override
  Widget build(BuildContext context) {

  double progress = (currentAmount / targetAmount) * 100;

    return Container(
      width: double.infinity, // Ensure the card takes up full width
      decoration: BoxDecoration(
        color: Colors.white, // Set background color to white
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black.withOpacity(0.2), // Set border color to black
          width: 1, // Set border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20), // Adjust margin
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Adjust padding
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16, // Adjust font size
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 2), // Adjust spacing
                  Text(
                    'Rp ${targetAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14, // Adjust font size
                      color: Colors.grey.shade600
                    ),
                  ),
                  SizedBox(height: 2), // Adjust spacing
                  Text(
                    '$deadline hari lagi',
                    style: TextStyle(
                      fontSize: 14, // Adjust font size
                      color: Colors.grey.shade600
                      // color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 2), // Adjust spacing
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12, // Adjust font size
                      color: Colors.grey.shade600
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
                      height: 40, // Adjust the size of the circular progress indicator
                      width: 40, // Adjust the size of the circular progress indicator
                      child: CircularProgressIndicator(
                        strokeWidth: 2, // Adjust thickness of the progress indicator
                        value: progress / 100, // Set progress value
                        backgroundColor: Colors.grey[300], // Background color
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // Progress color
                      ),
                    ),
                    Text(
                      '${(progress).toInt()}%', // Display progress percentage
                      style: TextStyle(
                        fontSize: 10, // Adjust font size
                        color: Colors.grey,
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

