import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProgressPopUp extends StatefulWidget {
  final String userId;
  final dynamic rencanaData;
  final String rencanaTabunganId;
  final Function(double) refreshData;

  const AddProgressPopUp({
    Key? key,
    required this.userId,
    required this.rencanaData,
    required this.rencanaTabunganId,
    required this.refreshData,
  }) : super(key: key);

  @override
  State<AddProgressPopUp> createState() => _AddProgressPopUpState();
}

class _AddProgressPopUpState extends State<AddProgressPopUp> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  String? _amountError;

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
      double targetAmount = widget.rencanaData['targetAmount'];
      double currentAmount = widget.rencanaData['currentAmount'] ?? 0;
      
      // Calculate remaining amount needed to reach target
      double remainingAmount = targetAmount - currentAmount;

      double inputAmount = double.tryParse(_amountController.text) ?? 0;
      
      // If input amount exceeds remaining amount, adjust it
      if (inputAmount > remainingAmount) {
        inputAmount = remainingAmount;
        _amountController.text = inputAmount.toString();
      }

      double newProgress = ((currentAmount + inputAmount) / targetAmount) * 100;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('rencanaTabungan')
          .doc(widget.rencanaTabunganId)
          .update({
        'currentAmount': currentAmount + inputAmount,
        'progress': newProgress,
      });

      widget.refreshData(currentAmount + inputAmount);
      Navigator.pop(context);
    } catch (e) {
      print('Failed to update progress: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Tabungan'),
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
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _amountError = 'Jumlah Tabungan tidak boleh kosong';
                  } else {
                    _amountError = (double.tryParse(value) ?? 0) <= 0
                        ? 'Masukan Jumlah Tabungan yang Valid'
                        : null;
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Jumlah Tabungan',
                errorText: _amountError,
                errorStyle: TextStyle(color: Colors.red),
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
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                double amount = double.tryParse(_amountController.text) ?? 0;
                if (amount > 0) {
                  _updateCurrentAmount(amount);
                } else {
                  setState(() {
                    _amountError = 'Masukan Jumlah Tabungan yang Valid';
                  });
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
