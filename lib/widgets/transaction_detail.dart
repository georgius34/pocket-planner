// ignore_for_file: use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/screen/dashboard.dart';

class TransactionDetailsPage extends StatelessWidget {
  final String userId;
  final dynamic transactionData;

  const TransactionDetailsPage({Key? key, required this.transactionData, required this.userId})
      : super(key: key);

   @override
  Widget build(BuildContext context) {
    // Extract transaction details
    final String title = transactionData['title'];
    final int amount = transactionData['amount'] as int;
    final String type = transactionData['type'];
    final DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(transactionData['timestamp']);

    // Format timestamp to dd MMM yyyy format
    final formattedDate = DateFormat('dd MMM yyyy').format(timestamp);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        title: Text('Transaction Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.green.shade600, // Set background color to green
            ),
          ),
           Positioned.fill(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity, // Make the container extend to the full width
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title: $title',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Amount: $amount',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Type: $type',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Date: $formattedDate',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Transaction'),
          content: Text('Are you sure you want to delete this transaction?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => _deleteTransaction(context),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

void _deleteTransaction(BuildContext context) async {
  try {
    // Retrieve the current user document
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Retrieve the type and amount of the transaction being deleted
    var type = transactionData['type'];
    var amount = transactionData['amount'] as int;

    // Retrieve the current values of totalCredit, totalDebit, and remainingAmount
    int totalCredit = userDoc['totalCredit'] as int;
    int totalDebit = userDoc['totalDebit'] as int;
    int remainingAmount = userDoc['remainingAmount'] as int;

    // Update totalCredit and totalDebit based on the type of transaction
    if (type == 'credit') {
      totalCredit -= amount;
    } else {
      totalDebit -= amount;
    }

    // Update remainingAmount based on the type of transaction
    remainingAmount += (type == 'credit') ? -amount : amount;

    // Update the user document in Firestore with the new values
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "totalCredit": totalCredit,
      "totalDebit": totalDebit,
      "remainingAmount": remainingAmount,
    });

    // Delete transaction from Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("transaction")
        .doc(transactionData['id'])
        .delete();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction deleted successfully')),
    );

    // Navigate back to Dashboard after deleting
     // Navigate back to Dashboard after deleting
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Dashboard(userId: userId),
      ),
      (route) => false, // Removes all the previous routes from the stack
    );
  } catch (e) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete transaction')),
    );
  }
}



}
