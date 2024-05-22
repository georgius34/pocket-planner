import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.selectedIndex, required this.onDestinationSelected});
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        indicatorColor: Colors.green.shade100,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color: Colors.green,
              size: 30,
              ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.book_rounded,
              color: Colors.green,
              size: 30,
              ),
            label: 'Laporan Keuangan',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.savings,
              color: Colors.green,
              size: 30,
              ),
            label: 'Rencana Tabungan',
          ),
        ],
      );
  }
}