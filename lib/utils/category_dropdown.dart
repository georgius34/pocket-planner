// Dropdown kategori kustom
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryDropDown extends StatelessWidget {
  CategoryDropDown({Key? key, required this.cattype, required this.onChanged}) : super(key: key);
  final String? cattype;
  final ValueChanged<String?> onChanged;
  final AppIcons appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.green.shade600),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: cattype,
          isExpanded: true,
          hint: Text("Select Category"),
          dropdownColor: Colors.green.shade900, // Set the background color of the dropdown items
                    iconEnabledColor: Colors.white, // Change arrow color to white
          items: appIcons.homeExpenseCategories.map((e) =>
            DropdownMenuItem<String>(
              value: e['name'],
              child: Row(
                children: [
                  Icon(
                    e['icon'],
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 15),
                  Text(
                    e['name'],
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// Kumpulan ikon aplikasi
class AppIcons {
  final List<Map<String, dynamic>> homeExpenseCategories = [
    {
      "name": "Gas Filling",
      "icon": FontAwesomeIcons.gasPump
    },
    {
      "name": "Grocery",
      "icon": FontAwesomeIcons.shoppingCart
    },
    {
      "name": "Education",
      "icon": FontAwesomeIcons.school
    },
      {
      "name": "Food",
      "icon": FontAwesomeIcons.bowlFood
    },
      {
      "name": "Transportation",
      "icon": FontAwesomeIcons.car
    },
      {
      "name": "Travelling",
      "icon": FontAwesomeIcons.campground
    },
      {
      "name": "Health",
      "icon": FontAwesomeIcons.hospital
    },
      {
      "name": "Cosmetic",
      "icon": FontAwesomeIcons.linesLeaning
    },
      {
      "name": "Others",
      "icon": FontAwesomeIcons.o
    }
  ];

  IconData getExpenseCategoryIcons(String categoryName) {
    final category = homeExpenseCategories.firstWhere(
      (category) => category['name'] == categoryName,
      orElse: () => {"icon": FontAwesomeIcons.shoppingCart}
    );
    return category['icon'];
  }
}