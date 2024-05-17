import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/screen/dashboard.dart';

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

  @override
  void initState() {
    super.initState();
    _transactionData = widget.transactionData;
  }

  @override
  Widget build(BuildContext context) {
    // Extract transaction details
    final String title = _transactionData['title'];
    final int amount = _transactionData['amount'] as int;
    final String type = _transactionData['type'];
    final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(_transactionData['timestamp']);
    final String category = _transactionData['category'];
    final String monthYear = _transactionData['monthyear'];
    final int remainingAmount = _transactionData['remainingAmount'] as int;
    final int totalCredit = _transactionData['totalCredit'] as int;
    final int totalDebit = _transactionData['totalDebit'] as int;

    // Format timestamp to dd MMM yyyy format
    final formattedDate = DateFormat('dd MMM yyyy').format(timestamp);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
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
                  Text(
                    'Transaction Details',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  _buildTransactionDetailsBox(
                    title,
                    amount,
                    category,
                    monthYear,
                    remainingAmount,
                    formattedDate,
                    totalCredit,
                    totalDebit,
                    type,
                  ),
                ],
              ),
            ),
        ),
      );
    }

  Widget _buildDetailBox(String label, String value) {
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

  Widget _buildTransactionDetailsBox(
    String title,
    int amount,
    String category,
    String monthYear,
    int remainingAmount,
    String date,
    int totalCredit,
    int totalDebit,
    String type,
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
                'Detail Rencana',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: Colors.green.shade900,
                ),
              ),
            //  ElevatedButton(
            //     onPressed: () async {
            //       String rencanaTabunganId = await _getRencanaTabunganId();
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return UpdateRencanaTabunganForm(
            //             rencanaTabunganId: rencanaTabunganId,
            //             userId: widget.userId,
            //             rencanaData: _rencanaData,
            //             refreshData: _refreshData,
            //           );
            //         },
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.green.shade600,
            //     ),
            //     child: Text('Edit Rencana', style: TextStyle(color: Colors.white)),
            //   ),
            ],
          ),
          SizedBox(height: 20),
          _buildDetailBox('Title', title),
          SizedBox(height: 5),
          _buildDetailBox('Amount', 'Rp ${amount.toString()}'),
          SizedBox(height: 5),
          _buildDetailBox('Category', category),
          SizedBox(height: 5),
          _buildDetailBox('Month Year', monthYear),
          SizedBox(height: 5),
          _buildDetailBox('Remaining Amount', 'Rp ${remainingAmount.toString()}'),
          SizedBox(height: 5),
          _buildDetailBox('Date', date),
          SizedBox(height: 5),
          _buildDetailBox('Total Credit', 'Rp ${totalCredit.toString()}'),
          SizedBox(height: 5),
          _buildDetailBox('Total Debit', 'Rp ${totalDebit.toString()}'),
          SizedBox(height: 5),
          _buildDetailBox('Type', type),
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
