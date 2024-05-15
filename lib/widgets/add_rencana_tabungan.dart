import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class _DateInputRow extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;

  const _DateInputRow({
    required this.label,
    required this.icon,
    required this.controller,
  });

  @override
  __DateInputRowState createState() => __DateInputRowState();
}

class __DateInputRowState extends State<_DateInputRow> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2), // Adjust vertical spacing
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
                widget.controller.text = DateFormat('dd/MM/yyyy').format(picked); // Updated date format without spaces

              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: widget.controller,
              style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w600, wordSpacing: 1.5),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(widget.icon, color: Colors.green.shade600),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AddRencanaTabunganForm extends StatefulWidget {
  final String userId;

  AddRencanaTabunganForm({required this.userId});

  @override
  _AddRencanaTabunganFormState createState() => _AddRencanaTabunganFormState();
}

class _AddRencanaTabunganFormState extends State<AddRencanaTabunganForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController(); // New field for end date
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bungaController = TextEditingController(); // New field for bunga (interest rate)

  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  var uid = Uuid(); // Buat instance dari UUID

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Generate UUID versi 4
      var id = uid.v4();

      // Calculate progress based on targetAmount and other factors
      double targetAmount = double.parse(_targetAmountController.text);
      double progress = 0; // default progress 0
      double currentAmount = 0; // default progress 0

        final startDate = DateTime.now(); // Start date is today's date
        final endDate = formatter.parse(_endDateController.text);
        final deadline = endDate.difference(DateTime.now()).inDays; // inisialisasi deadline


      await firestore.collection('users').doc(widget.userId).collection('rencanaTabungan').doc(id).set({
        'id': id,
        'title': _titleController.text,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'progress': progress,
        'startDate': formatter.format(startDate),
        'endDate': _endDateController.text, // Save end date to Firestore
        'deadline': deadline, // Save deadline to Firestore
        'description': _descriptionController.text,
        'bunga': _bungaController.text.isEmpty ? 0 : double.parse(_bungaController.text), // Save bunga if provided, otherwise save null
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), // Mengatur warna ikon back button
        backgroundColor: Colors.green.shade900,
        title: Text(
          'Tambah Rencana Tabungan',
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
              _buildInputRow('Title', Icons.title, _titleController),
              SizedBox(height: 10.0),
              _buildInputRow('Target Amount', Icons.monetization_on, _targetAmountController),
              SizedBox(height: 10.0),
              _DateInputRow(label: 'End Date', icon: Icons.calendar_today, controller: _endDateController),
              SizedBox(height: 10.0),
              _buildInputRow('Description', Icons.description, _descriptionController),
              SizedBox(height: 10.0),
              _buildInputRow('Bunga (Optional)', Icons.monetization_on, _bungaController),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit', style: TextStyle(color: Colors.green.shade600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2), // Adjust vertical spacing
        TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w600, wordSpacing: 1.5),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(icon, color: Colors.green.shade600),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}