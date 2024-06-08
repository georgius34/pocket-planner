import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/screen/dashboard.dart';
import 'package:pocket_planner/utils/detail_box.dart';
import 'package:pocket_planner/utils/format.dart';
import 'package:pocket_planner/widgets/transaction/update_transaction.dart';

class TransactionDetailsPage extends StatefulWidget {
  final String userId;
  final dynamic transactionData;

  const TransactionDetailsPage({Key? key, required this.transactionData, required this.userId})
      : super(key: key);

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  late dynamic _transactionData;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _transactionData = widget.transactionData;
  }

    void _updateTransactionData(dynamic newData) {
    setState(() {
      _transactionData = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract transaction details
    final String title = _transactionData['title'];
    final int amount = _transactionData['amount'] as int;
    final String category = _transactionData['category'];
    final String type = _transactionData['type'];
    final DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(_transactionData['createdAt']);
    final DateTime updatedAtDate = DateTime.fromMillisecondsSinceEpoch(_transactionData['updatedAt']);
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(_transactionData['dateTime']);
    final int remainingAmount = _transactionData['remainingAmount'] as int;
    final int totalCredit = _transactionData['totalCredit'] as int;
    final int totalDebit = _transactionData['totalDebit'] as int;

  // Format timestamp to dd MMM yyyy format
    final String createdAt = getDateTimeFormatter().format(createdAtDate);
    final String updatedAt = getDateTimeFormatter().format(updatedAtDate);
    final String formattedDateTime = getDateFormatter().format(dateTime);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(context),
          ),
        ],
      ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.green.shade900, // Set background color to green
            padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  _buildTransactionDetailsBox(
                    title,
                    amount,
                    category,
                    type,
                    formattedDateTime,
                    createdAt,
                    updatedAt,
                    remainingAmount,
                    totalCredit,
                    totalDebit,
                  ),
                ],
              ),
            ),
        ),
      );
    }

  Widget _buildTransactionDetailsBox(
    String title,
    int amount,
    String category,
    String type,
    String formattedDateTime,
    String createdAt,
    String updatedAt,
    int remainingAmount,
    int totalCredit,
    int totalDebit,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction Detail',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.green.shade900,
                ),
              ),
             ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UpdateTransactionForm(
                        userId: widget.userId,
                        transactionData: _transactionData,
                        onUpdate: _updateTransactionData, // Tambahkan callback
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0), // Adjust padding here
                      minimumSize: Size(135, 35), // Set minimum size to zero to allow for smaller dimensions
                ),
                child: Text('Update Transaction', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildDetailBox('Title', title),
          SizedBox(height: 5),
          buildDetailBox('Amount',  _currencyFormat.format(amount)),
          SizedBox(height: 5),
          buildDetailBox('Category', category),
          SizedBox(height: 5),
          buildDetailBox('Date Time', formattedDateTime),
          SizedBox(height: 5),
          buildDetailBox('Remaining Amount', 'Rp ${remainingAmount.toString()}'),
          SizedBox(height: 5),
          buildDetailBox('created At', createdAt),
          SizedBox(height: 5),
          buildDetailBox('updated At', updatedAt),
          SizedBox(height: 5),
          buildDetailBox('Total Credit',  _currencyFormat.format(totalCredit)),
          SizedBox(height: 5),
          buildDetailBox('Total Debit',  _currencyFormat.format(totalDebit)),
          SizedBox(height: 5),
          buildDetailBox('Type', type),
          SizedBox(height: 5),
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
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      // Retrieve the type and amount of the transaction being deleted
      var type = _transactionData['type'];
      var amount = _transactionData['amount'] as int;

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
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "remainingAmount": remainingAmount,
      });

      // Delete transaction from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection("transaction")
          .doc(_transactionData['id'])
          .delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction deleted successfully')),
      );

      // Navigate back to Dashboard after deleting
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(userId: widget.userId),
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
