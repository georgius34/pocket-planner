import 'package:flutter/material.dart';

class TransactionsCategoryDropdown extends StatefulWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;
  final List<Map<String, dynamic>> categories;

  TransactionsCategoryDropdown({
    required this.selectedCategory,
    required this.onChanged,
    required this.categories,
  });

  @override
  _TransactionsCategoryDropdownState createState() => _TransactionsCategoryDropdownState();
}

class _TransactionsCategoryDropdownState extends State<TransactionsCategoryDropdown> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 180,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: "Input Category",
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.green.shade900),
          contentPadding: EdgeInsets.only(bottom: 12), // Adjust this value
        ),
        style: TextStyle(color: Colors.green.shade900, fontSize: 16),
        onSubmitted: (text) {
          widget.onChanged(text.toLowerCase());
        },
      ),
    );
  }
}
