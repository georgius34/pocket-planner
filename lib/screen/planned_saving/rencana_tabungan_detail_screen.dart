// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:pocket_planner/screen/dashboard.dart';
import 'package:pocket_planner/utils/detail_box.dart';
import 'package:pocket_planner/utils/format.dart';
import 'package:pocket_planner/widgets/deadlineProgress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_planner/widgets/planned_saving/tabungan_detail.dart';
import 'package:pocket_planner/widgets/planned_saving/update_rencana_form.dart';
import 'package:intl/intl.dart';

class RencanaTabunganDetailScreen extends StatefulWidget {
  final String userId;
  final dynamic rencanaData;

  RencanaTabunganDetailScreen({
    required this.userId,
    required this.rencanaData,
  });

  @override
  State<RencanaTabunganDetailScreen> createState() =>
      _RencanaTabunganDetailScreenState();
}

class _RencanaTabunganDetailScreenState
    extends State<RencanaTabunganDetailScreen> {
  late dynamic _rencanaData;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _rencanaData = widget.rencanaData;
  }

    void _updateSavingData(dynamic newData) {
    setState(() {
      _rencanaData = newData;
    });
  }

  String _getRencanaTabunganId(String userId) {
    return _rencanaData['id'];
  }

  void _deleteTransaction(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection("rencanaTabungan")
          .doc(_rencanaData['id'])
          .delete();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(userId: widget.userId),
        ),
        (route) => false,
      ).then((_) {
        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete plan')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Plan'),
          content: Text('Are you sure you want to delete this plan?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  void _refreshData(int newAmount) {
    setState(() {
      _rencanaData['currentAmount'] = newAmount;
      _rencanaData['progress'] = ((newAmount / _rencanaData['targetAmount']) * 100).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = _rencanaData['title'];
    final int targetAmount = _rencanaData['targetAmount'];
    final int currentAmount = _rencanaData['currentAmount'];
    final int startDateEpoch = _rencanaData['startDate'];
    final int endDateEpoch = _rencanaData['endDate'];
    final String description = _rencanaData['description'];
    final int deadline = _rencanaData['deadline'];
    final int progress = _rencanaData['progress'];
    final int bunga = _rencanaData['interest'];
    final int taxRate = _rencanaData['taxRate'];
    final int totalInterest = _rencanaData['totalInterest'];
    final DateTime createdAtDate = DateTime.fromMillisecondsSinceEpoch(_rencanaData['createdAt']);
    final DateTime updatedAtDate = DateTime.fromMillisecondsSinceEpoch(_rencanaData['updatedAt']);
    final DateTime startDate = DateTime.fromMillisecondsSinceEpoch(startDateEpoch);
    final DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endDateEpoch);

    final String createdAt = getDateTimeFormatter().format(createdAtDate);
    final String updatedAt = getDateTimeFormatter().format(updatedAtDate);
        final String formattedStartDate = getDateTimeFormatter().format(startDate);
    final String formattedEndDate = getDateTimeFormatter().format(endDate);

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
          color: Colors.green.shade900,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabunganDetailBox(
                currentAmount: currentAmount,
                totalInterest: totalInterest,
                progress: progress,
                userId: widget.userId,
                rencanaData: _rencanaData,
                getRencanaTabunganId: _getRencanaTabunganId,
                refreshData: _refreshData,
              ),          
              SizedBox(height: 20),
              DeadlineAndProgressBox(deadline: deadline, progress: progress),
              SizedBox(height: 20),
              _buildRencanaBox(
                context,
                title,
                targetAmount,
                formattedStartDate,
                formattedEndDate,
                description,
                deadline,
                bunga,
                taxRate,
                createdAt,
                updatedAt,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildRencanaBox(
    BuildContext context,
    String title,
    int targetAmount,
    String startDate,
    String endDate,
    String description,
    int deadline,
    int bunga,
    int taxRate,
    String createdAt,
    String updatedAt,
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
                'Plan Detail',
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
                      return UpdateRencanaTabunganForm(
                        userId: widget.userId,
                        rencanaData: _rencanaData,
                        // onUpdate: _updateSavingData
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.green.shade600,
                    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0), // Adjust padding here
                    minimumSize: Size(135, 35), // Set minimum size to zero to allow for smaller dimensions
                ),
                child: Text('Update Plan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20),
          buildDetailBox('Title', title),
          SizedBox(height: 5),
          buildDetailBox('Target Amount', _currencyFormat.format(targetAmount)),
          SizedBox(height: 5),
          buildDetailBox('Start Date', startDate),
          SizedBox(height: 5),
          buildDetailBox('End Date', endDate),
          SizedBox(height: 5),
          buildDetailBox('Description', description),
          SizedBox(height: 5),
          buildDetailBox('Deadline', '$deadline hari'),
          SizedBox(height: 5),
          buildDetailBox('Interest', bunga.toString()),
          SizedBox(height: 5),
          buildDetailBox('Tax Rate', taxRate.toString()),
          SizedBox(height: 5),
          buildDetailBox('created At', createdAt),
          SizedBox(height: 5),
          buildDetailBox('updated At', updatedAt),
        ],
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

  Widget _buildCurrencyDetailRow(String label, int value) {
    return Container(
      child: SizedBox(
        width: 400,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              _currencyFormat.format(value),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
