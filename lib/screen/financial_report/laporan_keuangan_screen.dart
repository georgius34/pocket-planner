  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:pocket_planner/utils/pie_chart.dart';
  import 'package:pocket_planner/widgets/financial_report/category_detail_list.dart';
  import 'package:pocket_planner/utils/month_navigator.dart';

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
        if (transactionType != _selectedTransactionType) continue; // Filter out non-selected transactions
        if (amount < 0 && _selectedTransactionType == 'debit') continue; // Skip debit transactions
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
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: DefaultTabController(
              length: 2,
              child: TabBar(
                tabs: [
                  Tab(child: Text('Debit', style: TextStyle(fontSize: 16),)),
                  Tab(child: Text('Credit', style: TextStyle(fontSize: 16))),
                ],
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                onTap: (index) {
                  setState(() {
                    _selectedTransactionType = index == 0 ? 'credit' : 'debit';
                  });
                },
              ),
            ),
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
                    SizedBox(height: 50,),
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No Data Found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              var docs = snapshot.data!.docs;
              var filteredDocs = docs.where((doc) => doc['type'] == _selectedTransactionType).toList();
              if (filteredDocs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50,),
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No Data Found for $_selectedTransactionType',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                var pieData = _getPieChartData(filteredDocs);
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