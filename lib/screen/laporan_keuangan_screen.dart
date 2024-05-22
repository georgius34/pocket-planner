import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_planner/widgets/pie_chart.dart';
import 'package:pocket_planner/widgets/category_detail_list.dart';
import 'package:pocket_planner/widgets/month_navigator.dart';

class LaporanKeuanganScreen extends StatefulWidget {
  final String userId;

  const LaporanKeuanganScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<LaporanKeuanganScreen> createState() => _LaporanKeuanganScreenState();
}

class _LaporanKeuanganScreenState extends State<LaporanKeuanganScreen> {
  DateTime _selectedMonth = DateTime.now();
  String _selectedTransactionType = 'debit'; // Default to 'debit'

  // Function to process the transaction data into pie chart data
  Map<String, double> _getPieChartData(List<QueryDocumentSnapshot> docs) {
    Map<String, double> data = {};
    for (var doc in docs) {
      String category = doc['category'];
      double amount = doc['amount'] is int ? (doc['amount'] as int).toDouble() : doc['amount'];
      String transactionType = doc['type']; // Assuming you have a field 'type' in your document
      if (_selectedTransactionType == 'credit' && transactionType != 'credit') continue; // Filter out non-credit transactions
      if (_selectedTransactionType == 'debit' && transactionType != 'debit') continue; // Filter out non-debit transactions
      if (amount < 0) continue; // Skip debit transactions
      if (data.containsKey(category)) {
        data[category] = data[category]! + amount;
      } else {
        data[category] = amount;
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    // Start of the month
    DateTime startMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    // Start of the next month
    DateTime endMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            MonthNavigator(onMonthChanged: _updateSelectedMonth),
            Spacer(), // Add spacer to push MonthNavigator to the left
            DropdownButton<String>(
              value: _selectedTransactionType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTransactionType = newValue!;
                });
              },
              items: <String>['debit', 'credit']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                );
              }).toList(),
              underline: Container(
                height: 2,
                color: Colors.white, // Set underline color to white
              ),
              style: TextStyle(color: Colors.white), // Set default text color to white
              dropdownColor: Colors.green.shade900, // Set dropdown background color
              iconEnabledColor: Colors.white, // Set dropdown icon color to white
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection("transaction")
            .where('timestamp', isGreaterThanOrEqualTo: startMonth.millisecondsSinceEpoch)
            .where('timestamp', isLessThan: endMonth.millisecondsSinceEpoch)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline, // Icon for information
                    size: 48, // Set icon size
                    color: Colors.grey, // Set icon color
                  ),
                  SizedBox(height: 16), // Spacer
                  Text('No data available', style: TextStyle(fontSize: 18)), // Text for no data
                ],
              ),
            );
          } else {
            var docs = snapshot.data!.docs;
            var pieData = _getPieChartData(docs);
            var totalAmount = pieData.values.fold<double>(0, (sum, item) => sum + item);

            return SingleChildScrollView(
              child: Column(
                children: [
                  PieChartSample(data: pieData), // Add the Pie Chart here
                  Divider(), // Add a divider
                  CategoryDetailList(data: pieData, total: totalAmount), // Add the new widget here
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Method to update the selected month
  void _updateSelectedMonth(DateTime newMonth) {
    setState(() {
      _selectedMonth = newMonth;
    });
  }
}
