import 'package:flutter/material.dart';

class RencanaTabungan {
  final String title;
  final double targetAmount;
  final String startDate;
  final String description;

  RencanaTabungan({
    required this.title,
    required this.targetAmount,
    required this.startDate,
    required this.description,
  });
}

class RencanaTabunganWidget extends StatelessWidget {
  final RencanaTabungan rencana;

  const RencanaTabunganWidget({Key? key, required this.rencana}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(rencana.title),
      subtitle: Text('Target Amount: ${rencana.targetAmount}\nStart Date: ${rencana.startDate}\nDescription: ${rencana.description}'),
    );
  }
}
