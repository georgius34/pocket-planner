// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _bungaController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  int? _selectedPeriode;
  String? _selectedType; // Add selected type variable
  var isLoader = false;
  late dynamic _rencanaData;

  @override
  void initState() {
    super.initState();
    _rencanaData = widget.rencanaData;

    _titleController.text = _rencanaData['title'];
    _targetAmountController.text = _formatAmount(_rencanaData['targetAmount'].toString());
    _descriptionController.text = _rencanaData['description'];
    _bungaController.text = _rencanaData['bunga'].toString();
    _taxController.text = _rencanaData['taxRate'].toString();
    _selectedPeriode = _rencanaData['periode'];
    _selectedType = _rencanaData['type'];
    currentAmount = _rencanaData['currentAmount'];
  }

  @override
  void dispose() {
    _targetAmountController.dispose();
    _titleController.dispose();
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
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    String amountText = _targetAmountController.text.replaceAll(RegExp(r'[Rp,. ]'), '');
    var targetAmount = int.parse(amountText);
    int taxRate = _taxController.text.isEmpty ? 0 : int.parse(_taxController.text);
    int bunga = _bungaController.text.isEmpty ? 0 : int.parse(_bungaController.text);
    int periode = _selectedPeriode?? 1;
    String type = _selectedType?? "personal";

    // Calculate start and end dates
    final startDate = DateTime.now(); // Start date is today's date
    final endDate = DateTime(startDate.year, startDate.month + periode, startDate.day);
    final deadline = endDate.difference(startDate).inDays; // Calculate deadline

    int totalInterest = 0; // Initialize profit variable

    if (type == "bank") {
      double taxRateDouble = taxRate / 100;
      double profit = ( (bunga/100) * targetAmount * 30 * ((100-taxRateDouble)/100)) / 365;

      totalInterest = profit.toInt() * periode;
    }
    int newProgress = ((currentAmount / targetAmount) * 100).toInt();

    var data = {
      'title': _titleController.text,
      'targetAmount': targetAmount,
      'description': _descriptionController.text,
      'bunga': bunga,
      'periode': periode,
      'endDate': formatter.format(endDate), // Update end date in Firestore
      'deadline': deadline, // Update deadline in Firestore
      'type': type,
      'totalInterest': totalInterest,
      'taxRate': taxRate,
      'progress': newProgress,
    };

    await firestore.collection('users').doc(widget.userId).collection('rencanaTabungan').doc(widget.rencanaData['id']).update(data);
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
              _DropdownInputRow(
                label: 'Period (Per Month)',
                icon: Icons.date_range,
                value: _selectedPeriode,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedPeriode = newValue;
                  });
                },
                options: [1, 3, 6, 12],
              ),
              SizedBox(height: 10.0),
              // _buildDropDownTypeRow(), // Add drop down type row
              // SizedBox(height: 10.0),
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

  Widget _buildDropDownTypeRow() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Type',
        style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
      ),
      SizedBox(height: 2),
      SizedBox(
        height: 60,
        child: DropdownButtonFormField<String>(
          value: _selectedType ?? 'personal', // Default value is personal
          onChanged: (String? newValue) {
            setState(() {
              _selectedType = newValue;
            });
          },
          items: [
            DropdownMenuItem(
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Personal', style: TextStyle(color: Colors.white)),
                ],
              ),
              value: 'personal',
            ),
            DropdownMenuItem(
              child: Row(
                children: [
                  Icon(Icons.vertical_shades_closed, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Bank', style: TextStyle(color: Colors.white)),
                ],
              ),
              value: 'bank',
            ),
          ],
          dropdownColor: Colors.green.shade900,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Add icon for dropdown
          decoration: InputDecoration(
            fillColor: Colors.green.shade900,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
          validator: (value) {
            if (value == null) {
              return 'Please select a type';
            }
            return null;
          },
        ),
      ),
      if (_selectedType == 'bank') ...[
        SizedBox(height: 10.0),
        _buildInputRow('Interest Rate', Icons.monetization_on, _bungaController, null, isNumeric: true),
        SizedBox(height: 10.0),
        _buildInputRow('Tax Rate', Icons.account_balance, _taxController, null, isNumeric: true),
      ],
    ],
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