import 'package:flutter/material.dart';

class DeadlineAndProgressBox extends StatelessWidget {
  final int endDateEpoch;
  final int progress;
  final bool isComplete;

  DeadlineAndProgressBox({required this.progress, required this.isComplete, required this.endDateEpoch});

  @override
  Widget build(BuildContext context) {
     DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endDateEpoch);

    // Calculate the number of days remaining until the end date
    DateTime today = DateTime.now();
    int totalRemainingDays = endDate.difference(today).inDays;

    int remainingMonths = totalRemainingDays ~/ 30; // Calculate the remaining months

    // Set a minimum value of 0 for remainingMonths and remainingDays
    if (remainingMonths < 0) remainingMonths = 0;
    if (totalRemainingDays < 0) totalRemainingDays = 0;

     String remainingTimeText;
    if (totalRemainingDays > 30) {
      remainingTimeText = '$remainingMonths months';
    } else {
      remainingTimeText = '$totalRemainingDays  days';
    }
    Color statusColor = Colors.grey.shade600;
    String statusText = '';

    if (isComplete) {
      statusColor = Colors.green;
      statusText = 'Plan Completed';
    } else if (today.isAfter(endDate)) {
      statusColor = Colors.red;
      statusText = 'Plan is not Completed';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 1.0,
            spreadRadius: 1.5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 30,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deadline',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                      isComplete
                      ? statusText
                      : remainingTimeText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Center(
            child: Container(
              height: 30,
              child: VerticalDivider(
                color: Colors.grey.shade500,
                thickness: 1,
              ),
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.stacked_line_chart_outlined,
                    size: 30,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '$progress%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
