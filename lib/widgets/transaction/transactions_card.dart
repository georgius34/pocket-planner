import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocket_planner/widgets/transaction/transaction_card.dart';
import 'package:pocket_planner/widgets/transaction/transaction_detail.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables

class TransactionsCard extends StatelessWidget {
  final String userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedCategory;

  TransactionsCard({
    required this.userId,
    this.startDate,
    this.endDate,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          TransactionList(
            userId: userId,
            startDate: startDate,
            endDate: endDate,
            selectedCategory: selectedCategory,
          ),
        ],
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  final String userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedCategory; // New property to receive selected category

  TransactionList({
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

    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      String lowerCaseCategory = selectedCategory!.toLowerCase();
      query = query
          .where('category', isGreaterThanOrEqualTo: lowerCaseCategory)
          .where('category', isLessThanOrEqualTo: lowerCaseCategory + '\uf8ff');
    }
    
    query = query.orderBy('createdAt', descending: true);


    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
        }
      var data = snapshot.data!.docs;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length, // ini yg set jmlh data di listny
      physics: ScrollPhysics(),
      itemBuilder: (context, index){
        var cardData = data[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailsPage(
                      userId: userId, 
                      transactionData: cardData.data(),
                    ),
                  ),
                );
              },
              child: TransactionCard(data: cardData),
            );
          },
        );
      },
    );
  }
}