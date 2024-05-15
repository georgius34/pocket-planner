import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProgressPopUp extends StatefulWidget {
  final String userId;
  final dynamic rencanaData;
  final String rencanaTabunganId;

  const AddProgressPopUp({
    Key? key,
    required this.userId,
    required this.rencanaData, required this.rencanaTabunganId,
  }) : super(key: key);

  @override
  State<AddProgressPopUp> createState() => _AddProgressPopUpState();
}

class _AddProgressPopUpState extends State<AddProgressPopUp> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _updateCurrentAmount(double newAmount) async {
    setState(() {
      _isLoading = true;
    });

    try {
      double newProgress =
          (newAmount / widget.rencanaData['targetAmount']) * 100; // Adjusted calculation
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('rencanaTabungan')
          .doc(widget.rencanaTabunganId)
          .update({
        'currentAmount': newAmount,
        'progress': newProgress,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Progress added successfully!'),
        ),
      );
      Navigator.pop(context, newAmount);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update progress: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Tabungan'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Target Amount: ${widget.rencanaData['targetAmount']}',
              style: TextStyle(fontSize: 16),
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Tabungan',
              ),
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      actions: [
        ButtonBar(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                double amount =
                    double.tryParse(_amountController.text) ?? 0;
                if (amount > 0) {
                  double currentAmount = widget.rencanaData['currentAmount'] ??
                      0; // Adjusted currentAmount
                  double newAmount = currentAmount + amount;
                  _updateCurrentAmount(newAmount);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid progress amount.'),
                    ),
                  );
                }
              },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Save',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
