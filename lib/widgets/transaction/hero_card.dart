import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/format.dart';

class HeroCard extends StatelessWidget {
  final String userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedCategory;

  HeroCard({
    required this.userId,
    this.startDate,
    this.endDate,
    this.selectedCategory,
  });


  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("transaction");

  // Apply date filter
    if (startDate != null && endDate != null) {
      query = query.where('dateTime', isGreaterThanOrEqualTo: startDate!.millisecondsSinceEpoch);
      query = query.where('dateTime', isLessThanOrEqualTo: endDate!.millisecondsSinceEpoch + 86399999);
    }

    // Apply category filter
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    query = query.orderBy('createdAt', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        double totalCredit = 0;
        double totalDebit = 0;

        snapshot.data!.docs.forEach((doc) {
          var transaction = doc.data() as Map<String, dynamic>;
          if (transaction['type'] == 'credit') {
            totalCredit += transaction['amount'];
          } else if (transaction['type'] == 'debit') {
            totalDebit += transaction['amount'];
          }
        });

        double remainingAmount = totalCredit - totalDebit;

        return Cards(
          totalCredit: totalCredit,
          totalDebit: totalDebit,
          remainingAmount: remainingAmount,
        );
      },
    );
  }
}

class Cards extends StatelessWidget {
  final double totalCredit;
  final double totalDebit;
  final double remainingAmount;

  const Cards({
    required this.totalCredit,
    required this.totalDebit,
    required this.remainingAmount,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = getCurrencyFormatter();

    return Container(
      color: Colors.green.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Balance",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      height: 1.2,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  currencyFormatter.format(remainingAmount),
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      height: 1.2,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  CardOne(
                    color: Colors.green,
                    heading: 'Credit',
                    amount: currencyFormatter.format(totalCredit),
                  ),
                  SizedBox(width: 10), // space
                  CardOne(
                    color: Colors.red,
                    heading: 'Debit',
                    amount: currencyFormatter.format(totalDebit),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}



class CardOne extends StatelessWidget {
  const CardOne({
    super.key,
    required this.color,
    required this.heading,
    required this.amount,
  });

  final Color color;
  final String heading;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: TextStyle(color: color, fontSize: 15),
                  ),
                  Text(
                    amount,
                    style: TextStyle(color: color, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
