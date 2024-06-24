import 'package:flutter/material.dart';

class TransactionsCategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;
  final List<Map<String, dynamic>> categories;

  TransactionsCategoryDropdown({
    required this.selectedCategory,
    required this.onChanged,
    required this.categories,
  });

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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          hint: Text(
            "Select Category",
            style: TextStyle(color: Colors.green.shade900, fontSize: 16),
          ),
          dropdownColor: Colors.white,
          items: categories.map((e) {
            return DropdownMenuItem<String>(
              value: e['name'],
              child: Row(
                children: [
                  Icon(
                    e['icon'],
                    color: Colors.green.shade900,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    e['name'],
                    style: TextStyle(color: Colors.green.shade900),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
