import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//ini harus di jelasin nanti kalau jika rencananya masih belum terpenuhi maka
//harus disamain dengan perancangan di bab 4
//mekanisme menabung harus dijelasin di perancangan

class AddProgressPopUp extends StatefulWidget {
  final String userId;
  final dynamic rencanaData;
  final String rencanaTabunganId;
  final Function(int) refreshData;

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
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatAmount);
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatAmount);
    super.dispose();
  }

void _formatAmount() {
  String currentText = _amountController.text;
  if (currentText.isEmpty) return;

  // Remove non-digit characters
  String digits = currentText.replaceAll(RegExp(r'[^\d]'), '');
  if (digits.isEmpty) return;

  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  String formatted = formatter.format(int.parse(digits));

  _amountController.value = TextEditingValue(
    text: formatted,
    selection: TextSelection.collapsed(offset: formatted.length),
  );
}


Future<void> _updateCurrentAmount() async {
  setState(() {
    _isLoading = true;
  });

  try {
    int targetAmount = widget.rencanaData['targetAmount'].toInt();
    int currentAmount = widget.rencanaData['currentAmount'].toInt() ?? 0;
    int periode = widget.rencanaData['periode'];

    // Parse the amount directly from the text field's value
    String amountText = _amountController.text.replaceAll(RegExp(r'[Rp,. ]'), '');
    int inputAmount = int.parse(amountText); // Change double to int

    // Calculate remaining amount needed to reach target
    int remainingAmount = targetAmount - currentAmount;

    // If input amount exceeds remaining amount, adjust it
    if (inputAmount > remainingAmount) {
      inputAmount = remainingAmount;
      _formatAmount(); // Call _formatAmount() to update the text field's value
    }
    // Calculate new remaining amount
    remainingAmount -= inputAmount;

    // Deduct one month from the period
    periode -= 1; 

    // Check if the plan is complete
    bool isPlanComplete = (remainingAmount <= 0 || periode <= 0);

    // Calculate new monthly saving only if the plan is not complete
    int monthlySaving = isPlanComplete ? 0 : (remainingAmount / periode).ceil();

    double progressDouble = ((currentAmount + inputAmount) / targetAmount) * 100;
    int newProgress = progressDouble.toInt();

    // Prepare update data
    Map<String, dynamic> updateData = {
      'currentAmount': currentAmount + inputAmount,
      'progress': newProgress,
      'monthlySaving': monthlySaving,
      'periode': periode,
      'isComplete': isPlanComplete,
    };

    await FirebaseFirestore.instance
       .collection('users')
       .doc(widget.userId)
       .collection('rencanaTabungan')
       .doc(widget.rencanaTabunganId)
       .update(updateData);

    widget.refreshData(currentAmount + inputAmount);
    // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Progresss added successfully')),
      );
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
      title: Text('Add Saving'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Target Amount: ${currencyFormat.format(widget.rencanaData['targetAmount'])}',
              style: TextStyle(fontSize: 16),
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _amountError = 'Amount must not be empty';
                  } else {
                    _amountError = (int.tryParse(value.replaceAll('Rp ', '').replaceAll('.', '')) ?? 0) <= 0
                        ? 'Please input a valid amount'
                        : null;
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Saving Amount',
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
                int amount = int.tryParse(_amountController.text.replaceAll('Rp ', '').replaceAll('.', '')) ?? 0;
                if (amount > 0) {
                  _updateCurrentAmount();
                } else {
                  setState(() {
                    _amountError = 'Please input a valid amount';
                  });
                }
              },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Add',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}