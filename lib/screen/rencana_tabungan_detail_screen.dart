import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RencanaTabunganDetailScreen extends StatelessWidget {
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String startDate;
  final String description;
  final int    deadline;
  final double progress; // Add progress as a parameter

  const RencanaTabunganDetailScreen({
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.startDate,
    required this.description,
    required this.deadline,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rencana Tabungan Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom Paint for semi-circle progress display
               SizedBox(
                  width: 340,
                  height: 210,
                  child: Padding(
                    padding: EdgeInsets.only(top: 140), // Atur jarak ke atas
                    child: CustomPaint(
                      painter: ProgressPainter(
                        progress: progress,
                        targetAmount: targetAmount,
                        currentAmount: currentAmount,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(0, -60), // Pindahkan teks ke atas
                              child: Text(
                                'Total Tabungan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, -50),
                              child: Text(
                                'Rp ${currentAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
                  Container(
                      width: 400,
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Atur padding secara simetris
                       decoration: BoxDecoration(
                          color: Colors.white, // Ubah warna latar belakang menjadi putih
                          borderRadius: BorderRadius.circular(10),
                           border: Border.all(
                              color: Colors.black.withOpacity(0.2), // Set border color to black
                              width: 1, // Set border width
                            ), // Tambahkan garis tepi hitam
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
                          // Left data
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
                                    SizedBox(width: 5), // Jarak antara ikon dan teks
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tenggat Waktu',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        Text(
                                          '${deadline} hari',
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
                           Spacer(),
                           Center(
                             child: Padding(
                               padding: const EdgeInsets.only(right: 30),
                               child: Container(
                                  height: 30,
                                  child: VerticalDivider(
                                    color: Colors.grey.shade500,
                                    thickness: 1,
                                  ),
                                ),
                             ),
                           ),
                            Spacer(),
                          // Right data (Progress)
                         Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline, // Ganti dengan ikon progress yang diinginkan
                                    size: 30,
                                    color: Colors.green.shade600,
                                  ),
                                  SizedBox(width: 5), // Jarak antara ikon dan teks
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Progress',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      Text(
                                        '${progress}%',
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
                    ),
                    SizedBox(height: 10),
              Text(
                '${(progress).toInt()}%',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  wordSpacing: 10,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Title: $title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Target Amount: Rp ${targetAmount.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Start Date: $startDate'),
              SizedBox(height: 8),
              Text('Description: $description'),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
   final double progress;
  final double targetAmount;
  final double currentAmount;

  ProgressPainter({
    required this.progress,
    required this.targetAmount,
    required this.currentAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint progressPaint = Paint()
      ..color = Colors.green.shade600
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    double progress = (currentAmount / targetAmount) * 100;

    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;

    final double startAngle = -math.pi; // Dimulai dari kiri
    final double sweepAngle = math.pi * progress / 100;
    final double sweepAngleBack = math.pi * 100 / 100;
    final Rect rect = Rect.fromCircle(center: Offset(halfWidth, halfHeight), radius: halfWidth);

    canvas.drawArc(rect, startAngle, sweepAngleBack, false, backgroundPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

