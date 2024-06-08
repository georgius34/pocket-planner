import 'package:flutter/material.dart';
import 'package:pocket_planner/widgets/transaction/add_transaction.dart';
import 'package:pocket_planner/widgets/transaction/hero_card.dart';
import 'package:pocket_planner/widgets/transaction/transactions_card.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: sized_box_for_whitespace

class TransactionScreen extends StatefulWidget {
  final String userId;
  const TransactionScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  _dialogBuilder(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: AddTransactionForm(userId: widget.userId), // Pass userId here
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green.shade900,
              onPressed: ((){
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionForm(userId: widget.userId),
                  ),
                );
              }),
              child: Icon(Icons.add, color: Colors.white),
            ),
            appBar: AppBar(
              backgroundColor: Colors.green.shade900,
      ),
      body: Container(  
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeroCard(userId: widget.userId),
              TransactionsCard(userId: widget.userId),
            ],
          ),
        )),
    );
  }
}