
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: sort_child_properties_last

class HeroCard extends StatelessWidget {
  HeroCard({
    super.key, required this.userId,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
      final Stream<DocumentSnapshot> _usersStream = 
    FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Document does not exist');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        var data = snapshot.data!.data() as Map<String, dynamic>;

        return Cards(data: data);
      },
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key, required this.data,
  });

  final Map data;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade900,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //bikin all left
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
                  "Rp ${data['remainingAmount']}",
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), //pake only klo mau spesifik arah
              color: Colors.white,
            ),
            child: Row( children: [
                CardOne(
                  color: Colors.green,
                   heading: 'Credit', amount: "${data['totalCredit']}",),
                SizedBox(width: 10), // space
                CardOne(
                  color: Colors.red,
                   heading: 'Debit', amount: "${data['totalDebit']}",),
              ],
            )
          )
        ],
      ),
    );
  }
}

class CardOne extends StatelessWidget {
  const CardOne({
    super.key,
     required this.color,
     required this.heading, required this.amount, // bikin bewarna
  });

  final Color color;
  final String heading;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
                    color: color.withOpacity(0.2), //bikin pudar
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.1), // Set border color to black
                      width: 1, // Set border width
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
                   style: TextStyle(color: color, fontSize: 14)),
                Text(
                  "Rp ${amount}",
                  style: TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.bold))
                  ],
              ),
              Spacer(),
              Icon(
                heading == "Credit"
                ? Icons.arrow_upward_outlined
                : Icons.arrow_downward_outlined,
                color: color,
                )
            ],
          ),
        ),
      ),
    );
  }
}