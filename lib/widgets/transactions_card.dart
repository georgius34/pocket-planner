import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_planner/widgets/transaction_card.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables

class TransactionsCard extends StatelessWidget {
  final String userId;

  TransactionsCard({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "List Transaksi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
              ],
            ),
            TransactionList(userId: userId)
        ],
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  final String userId;
  
 TransactionList({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection("transaction")
      .orderBy('timestamp', descending: true)
      .limit(20)
      .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return const Center(child: Text('No transactions found'),);
        }
      var data = snapshot.data!.docs;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length, // ini yg set jmlh data di listny
      physics: ScrollPhysics(),
      itemBuilder: (context, index){
        var cardData = data[index];
      return TransactionCard(data: cardData);
    });
    });
  }
}