import 'package:flutter/material.dart';
import 'package:pocket_planner/screen/transaction/transaction_screen.dart';
import 'package:pocket_planner/screen/financial_report/laporan_keuangan_screen.dart';
import 'package:pocket_planner/screen/planned_saving/rencana_tabungan_screen.dart';
import 'package:pocket_planner/widgets/navbar.dart';
//ignore_for_file: prefer_const_constructors
// ignore_for_file: use_super_parameters

class Dashboard extends StatefulWidget {
  final String userId;
  final int initialIndex;

  const Dashboard({Key? key, required this.userId, this.initialIndex = 0}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  var pageViewList;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageViewList = [
      TransactionScreen(userId: widget.userId),
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
