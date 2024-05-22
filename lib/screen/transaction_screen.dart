import 'package:flutter/material.dart';
import 'package:pocket_planner/widgets/add_transaction.dart';
import 'package:pocket_planner/widgets/hero_card.dart';
import 'package:pocket_planner/widgets/transactions_card.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: sized_box_for_whitespace

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
              backgroundColor: Colors.green.shade600,
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
              // title: Text(
              //   'Dashboard',
              //   style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500, wordSpacing: 1.2),
              // ),
              
        // actions: [IconButton(onPressed: , icon: )],
      ),
      body: Container(  
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeroCard(userId: widget.userId), // Use widget.userId
              TransactionsCard(userId: widget.userId),
            ],
          ),
        )), // ini color bodyny
    );
  }
}