// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:pocket_planner/utils/global_input.dart';

class UpdateRencanaTabunganForm extends StatefulWidget {
  final String userId;
  final dynamic rencanaData;

  UpdateRencanaTabunganForm({
    required this.userId,
    required this.rencanaData,
  });

  @override
  _UpdateRencanaTabunganFormState createState() => _UpdateRencanaTabunganFormState();
}

class _UpdateRencanaTabunganFormState extends State<UpdateRencanaTabunganForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int currentAmount;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  var isLoader = false;
  late dynamic _rencanaData;
  var appValidator = AppValidator();


  @override
  void initState() {
    super.initState();
    _rencanaData = widget.rencanaData;

    _titleController.text = _rencanaData['title'];
    _targetAmountController.text = _formatAmount(_rencanaData['targetAmount'].toString());
    _descriptionController.text = _rencanaData['description'];
  _periodController.text = _rencanaData['period'].toString();
    currentAmount = _rencanaData['currentAmount'];
  }

  @override
  void dispose() {
    _targetAmountController.dispose();
    _titleController.dispose();
    _periodController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
String _formatAmount(String amount) {
  if (amount.isEmpty) return '';

  String digits = amount.replaceAll(RegExp(r'[^\d]'), '');
  if (digits.isEmpty) return '';

  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return formatter.format(int.parse(digits));
}

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String amountText = _targetAmountController.text.replaceAll(RegExp(r'[Rp,. ]'), '');
    var targetAmount = int.parse(amountText);
    int period = int.parse(_periodController.text); 

    // Calculate start and end dates
    final startDate = DateTime.now();
    final endDate = DateTime(startDate.year, startDate.month + period, startDate.day);
    int endDateEpoch = endDate.millisecondsSinceEpoch;

    int newProgress = ((currentAmount / targetAmount) * 100).toInt();
    int monthlySaving = ((targetAmount-currentAmount) / period).ceil();

    var data = {
      'title': _titleController.text,
      'targetAmount': targetAmount,
      'description': _descriptionController.text,
      'period': period,
      'monthlySaving': monthlySaving,
      'endDate': endDateEpoch,
      'progress': newProgress,
    };

    await firestore.collection('users').doc(widget.userId).collection('plannedSaving').doc(widget.rencanaData['id']).update(data);
   setState(() {
          isLoader = false;
        });
      // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Planned Saving updated successfully')),
      );
    Navigator.pop(context);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), // Mengatur warna ikon back button
        backgroundColor: Colors.green.shade900,
        title: Text(
          'Update Planned Saving',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputRow('Title', Icons.title, _titleController, null),
              SizedBox(height: 10.0),
              _buildInputRow('Target Amount', Icons.monetization_on, _targetAmountController,  null, isNumeric: true),
              SizedBox(height: 10.0),
              buildInputRow(
                label: 'Period (Per Month 1 - 12)',
                icon: Icons.date_range,
                controller: _periodController,
                validator: appValidator.validatePeriod,
                isAmount: true,
              ),
              SizedBox(height: 10.0),
              _buildInputRow('Description', Icons.description, _descriptionController, null),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900, // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
                child: Text('Update', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildInputRow(String label, IconData icon, TextEditingController controller, String? Function(String?)? validator, {bool isNumeric = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
          style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
      ),
      SizedBox(height: 2),
      TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        decoration: InputDecoration(
          fillColor: Colors.green.shade900,
          filled: true,
          prefixIcon: Icon(icon, color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade900),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade900),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (value) {
          if (isNumeric) {
            // Remove non-numeric characters
            String digits = value.replaceAll(RegExp(r'[^\d]'), '');
            // Format the amount
            final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
            String formatted = formatter.format(int.parse(digits));
            // Update the controller value with the formatted text
            controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        },
      ),
    ],
  );
}
}

class _DropdownInputRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int? value;
  final ValueChanged<int?> onChanged;
  final List<int> options;
  final String? Function(String?)? validator;

  const _DropdownInputRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.options,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2),
        DropdownButtonFormField<int>(
          value: value,
          icon: null,
          decoration: InputDecoration(
            fillColor: Colors.green.shade900,
            filled: true,
            prefixIcon: Icon(icon, color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString(), style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          isExpanded: true,
          dropdownColor: Colors.green.shade900,
          validator: (value) {
            if (value == null) {
              return 'Please select a period';
            }
            return null;
          },
        ),
      ],
    );
  }
}