import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons{
  final List<Map<String, dynamic>> homeExpenseCategories = [
    //hrs ditmbh ad di 1:08:28
    {
      "name": "Gas Filling",
      "icon" : FontAwesomeIcons.gasPump
    },
    {
      "name": "Grocery",
      "icon" : FontAwesomeIcons.shoppingCart
    },
    {
      "name": "Home",
      "icon" : FontAwesomeIcons.addressBook
    }
  ];
  

IconData getExpenseCategoryIcons(String categoryName) {
  final category = homeExpenseCategories.firstWhere(
    (category) => category['name'] == categoryName,
    orElse: () => {"icon": FontAwesomeIcons.shoppingCart}
  );
  return category['icon']; // This should return an IconData
}
}