import 'package:flutter/material.dart';
import 'package:pocket_planner/screen/home_screen.dart';
import 'package:pocket_planner/screen/transaction.dart';
import 'package:pocket_planner/widgets/navbar.dart';
//ignore_for_file: prefer_const_constructors

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  var pageViewList = [HomeScreen(), TransactionScreen()];

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