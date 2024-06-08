import 'package:flutter/material.dart';

Widget buildDetailBox(String label, String value) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 4.0),
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: Colors.black.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 1.0,
          spreadRadius: 1.5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    ),
  );
}
