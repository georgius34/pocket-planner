import 'package:flutter/material.dart';
import 'package:pocket_planner/screen/dashboard.dart';
import 'package:pocket_planner/widgets/add_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_planner/widgets/update_rencana_form.dart';
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
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    _rencanaData = widget.rencanaData;
  }

  Future<String> _getRencanaTabunganId() async {
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
        SnackBar(content: Text('Failed to delete transaction')),
      );
    }
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

  void _refreshData(double newAmount) {
    setState(() {
      _rencanaData['currentAmount'] = newAmount;
      _rencanaData['progress'] =
          (newAmount / _rencanaData['targetAmount']) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = _rencanaData['title'];
    final double targetAmount = _rencanaData['targetAmount'];
    final double currentAmount = _rencanaData['currentAmount'];
    final String startDate = _rencanaData['startDate'];
    final String endDate = _rencanaData['endDate'];
    final String description = _rencanaData['description'];
    final int deadline = _rencanaData['deadline'];
    final double progress = _rencanaData['progress'];
    final int bunga = _rencanaData['bunga'];
    final double tabunganBulanan = _rencanaData['tabunganBulanan'];

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
              _buildTabunganBox(currentAmount, tabunganBulanan, progress),
              SizedBox(height: 20),
              _buildDeadlineAndProgressBox(deadline, progress),
              SizedBox(height: 20),
              _buildRencanaBox(
                context,
                title,
                targetAmount,
                startDate,
                endDate,
                description,
                deadline,
                bunga,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabunganBox(
      double currentAmount, double tabunganBulanan, double progress) {
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
                'Detail Tabungan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: Colors.green.shade900,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String rencanaTabunganId = await _getRencanaTabunganId();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddProgressPopUp(
                        rencanaTabunganId: rencanaTabunganId,
                        rencanaData: _rencanaData,
                        userId: widget.userId,
                        refreshData: _refreshData,
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
                child: Text('Add Tabungan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress / 100,
            borderRadius: BorderRadius.circular(20.0),
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            minHeight: 30,
            semanticsLabel: 'Progress Indicator',
          ),
          SizedBox(height: 10),
          _buildCurrencyDetailRow('Total Tabungan Sekarang', currentAmount),
          SizedBox(height: 5),
          _buildCurrencyDetailRow('Tabungan Bulanan', tabunganBulanan),
        ],
      ),
    );
  }

  Widget _buildDeadlineAndProgressBox(int deadline, double progress) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
         
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 1.0,
            spreadRadius: 1.5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 30,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tenggat Waktu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '$deadline hari',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Container(
                height: 30,
                child: VerticalDivider(
                  color: Colors.grey.shade500,
                  thickness: 1,
                ),
              ),
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.stacked_line_chart_outlined,
                    size: 30,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '${progress.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRencanaBox(
    BuildContext context,
    String title,
    double targetAmount,
    String startDate,
    String endDate,
    String description,
    int deadline,
    int bunga,
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
             ElevatedButton(
                onPressed: () async {
                  String rencanaTabunganId = await _getRencanaTabunganId();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UpdateRencanaTabunganForm(
                        rencanaTabunganId: rencanaTabunganId,
                        userId: widget.userId,
                        rencanaData: _rencanaData,
                        refreshData: _refreshData,
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
                child: Text('Edit Rencana', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildDetailBox('Title', title),
          SizedBox(height: 5),
          _buildDetailBox('Target Amount', _currencyFormat.format(targetAmount)),
          SizedBox(height: 5),
          _buildDetailBox('Start Date', startDate),
          SizedBox(height: 5),
          _buildDetailBox('End Date', endDate),
          SizedBox(height: 5),
          _buildDetailBox('Description', description),
          SizedBox(height: 5),
          _buildDetailBox('Deadline', '$deadline hari'),
          SizedBox(height: 5),
          _buildDetailBox('Bunga', bunga.toString()),
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

  Widget _buildCurrencyDetailRow(String label, double value) {
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
