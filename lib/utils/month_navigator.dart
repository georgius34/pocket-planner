import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthNavigator extends StatefulWidget {
  final Function(DateTime) onMonthChanged;

  const MonthNavigator({Key? key, required this.onMonthChanged}) : super(key: key);

  @override
  _MonthNavigatorState createState() => _MonthNavigatorState();
}

class _MonthNavigatorState extends State<MonthNavigator> {
  DateTime _selectedMonth = DateTime.now();

  void _prevMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
      widget.onMonthChanged(_selectedMonth);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
      widget.onMonthChanged(_selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: _prevMonth,
        ),
        Text(
          DateFormat.yMMMM().format(_selectedMonth), // Use default locale
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white), // Set text color
        ),

        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }
}
