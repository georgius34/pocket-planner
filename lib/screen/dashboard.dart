import 'package:flutter/material.dart';
import 'package:pocket_planner/screen/transaction_screen.dart';
import 'package:pocket_planner/screen/laporan_keuangan_screen.dart';
import 'package:pocket_planner/screen/rencana_tabungan_screen.dart';
import 'package:pocket_planner/widgets/navbar.dart';
//ignore_for_file: prefer_const_constructors
// ignore_for_file: use_super_parameters

class Dashboard extends StatefulWidget {
  final String userId; // Add userId as a parameter
  final int initialIndex; // Add initialIndex as a parameter

  const Dashboard({Key? key, required this.userId, this.initialIndex = 0}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  var pageViewList; // Initialize pageViewList in initState()

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // Gunakan nilai initialIndex yang diteruskan
    // Initialize pageViewList with HomeScreen and RencanaTabunganScreen widgets
    pageViewList = [
      HomeScreen(userId: widget.userId), // Pass userId to HomeScreen
      LaporanKeuanganScreen(userId: widget.userId),
      RencanaTabunganScreen(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),

      body: pageViewList[currentIndex],
    );
  }
}
