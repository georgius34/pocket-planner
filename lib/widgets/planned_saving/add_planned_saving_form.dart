// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/global_input.dart';
import 'package:uuid/uuid.dart';
import 'package:pocket_planner/utils/appvalidators.dart';

class AddRencanaTabunganForm extends StatefulWidget {
  final String userId;

  const AddRencanaTabunganForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddRencanaTabunganForm> createState() => _AddRencanaTabunganFormState();
}

class _AddRencanaTabunganFormState extends State<AddRencanaTabunganForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var periodController = TextEditingController();
  var targetAmountController = TextEditingController();
  var descriptionController = TextEditingController();
  var bungaController = TextEditingController();
  var taxController = TextEditingController(); // Add tax controller
  String? _selectedType; // Add selected type variable
  var uid = Uuid();

  var appValidator = AppValidator();

  @override
  void initState() {
    super.initState();
    targetAmountController.addListener(_formatAmount);
  }

  @override
  void dispose() {
    targetAmountController.removeListener(_formatAmount);
    titleController.dispose();
    periodController.dispose();
    targetAmountController.dispose();
    descriptionController.dispose();
    bungaController.dispose();
    taxController.dispose();
    super.dispose();
  }

  void _formatAmount() {
    String currentText = targetAmountController.text;
    if (currentText.isEmpty) return;

    String digits = currentText.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return;

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    String formatted = formatter.format(int.parse(digits));

    targetAmountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _submitForm(String userId) async {
  if (_formKey.currentState!.validate()) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var id = uid.v4();
    String amountText = targetAmountController.text.replaceAll(RegExp(r'[Rp,. ]'), '');
    int targetAmount = int.parse(amountText);
    int progress = 0;
    int currentAmount = 0;
    int taxRate = taxController.text.isEmpty ? 0 : int.parse(taxController.text);
    int bunga = bungaController.text.isEmpty ? 0 : int.parse(bungaController.text);
    int period = int.parse(periodController.text);
    String type = _selectedType ?? "personal";

    final startDate = DateTime.now();
    final endDate = DateTime(startDate.year, startDate.month + period, startDate.day);
    int startDateEpoch = startDate.millisecondsSinceEpoch;
    int endDateEpoch = endDate.millisecondsSinceEpoch;
    DateTime now = DateTime.now();
    int millisecondsSinceEpoch = now.millisecondsSinceEpoch;

    int totalInterest = 0; // Initialize profit variable as int

    if (type == "bank") {
      int taxRate = taxController.text.isEmpty ? 0 : int.parse(taxController.text);

      double profit = ( (bunga/100) * targetAmount * 30 * ((100-taxRate)/100)) / 365;

      totalInterest = (profit * period).toInt(); // Change double to int
    }
      int monthlySaving = (targetAmount / period).ceil();

    await firestore.collection('users').doc(widget.userId).collection('plannedSaving').doc(id).set({
      'id': id,
      'title': titleController.text,
      'interest': bunga,
      'taxRate': taxRate,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'totalInterest': totalInterest,
      'monthlySaving': monthlySaving,
      'period': period,
      'progress': progress,
      'description': descriptionController.text,
      'type': type,
      'startDate': startDateEpoch,
      'endDate': endDateEpoch,
      'isComplete': false,
      'createdAt': millisecondsSinceEpoch,
      'updatedAt': millisecondsSinceEpoch,
    });
      // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Planned Saving added successfully')),
      );

    Navigator.pop(context);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green.shade900,
        title: Text(
          'Add Planned Saving',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               buildInputRow(
                label: 'Title',
                icon: Icons.title,
                controller: titleController,
                validator: appValidator.isEmptyCheck,
              ),
              SizedBox(height: 10.0),
              buildInputRow(
                label: 'Target Amount',
                icon: Icons.monetization_on,
                controller: targetAmountController,
                validator: appValidator.validateAmount,
                isAmount: true,
              ),
              SizedBox(height: 10.0),
                 buildInputRow(
                label: 'Period (Per Month 1 - 12)',
                icon: Icons.date_range,
                controller: periodController,
                validator: appValidator.validatePeriod,
                isAmount: true,
              ),
              SizedBox(height: 10.0),
              buildDropDownPlanTypeRow(
                selectedType: _selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                bungaController: bungaController,
                taxController: taxController,
              ),
              SizedBox(height: 10.0),
                buildInputRow(
                label: 'Description',
                icon: Icons.description,
                controller: descriptionController,
                validator: null,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm(widget.userId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900, // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
                child: Text('Submit', style: TextStyle(fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
