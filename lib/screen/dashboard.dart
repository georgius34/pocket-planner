import 'package:flutter/material.dart';
import 'package:pocket_planner/screen/home_screen.dart';
import 'package:pocket_planner/screen/transaction.dart';
import 'package:pocket_planner/widgets/navbar.dart';
//ignore_for_file: prefer_const_constructors

class Dashboard extends StatefulWidget {
  final String userId; // Add userId as a parameter

  const Dashboard({Key? key, required this.userId}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  var pageViewList; // Initialize pageViewList in initState()

  @override
  void initState() {
    super.initState();
    // Initialize pageViewList with HomeScreen and TransactionScreen widgets
    pageViewList = [
      HomeScreen(userId: widget.userId), // Pass userId to HomeScreen
      TransactionScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(selectedIndex: currentIndex, 
      onDestinationSelected: (int value) { 
        setState(() {
          currentIndex = value;
        });
       },),

      body: pageViewList[currentIndex],
    );
  }
}