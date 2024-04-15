import 'package:flutter/material.dart';
import 'package:pocket_planner/widgets/hero_card.dart';
import 'package:pocket_planner/widgets/transaction_card.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green.shade600,
        // actions: [IconButton(onPressed: , icon: )],
      ),
      body: Container(  
        width: double.infinity,
        child: Column(
          children: [
            HeroCard(),
            TransactionCard(),
          ],
        )), // ini color bodyny
    );
  }
}