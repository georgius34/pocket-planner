import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('users').doc(widget.userId).collection('rencanaTabungan').add({
        'title': _titleController.text,
        'targetAmount': double.parse(_targetAmountController.text),
        'startDate': _startDateController.text,
        'description': _descriptionController.text,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text(
          'Tambah Rencana Tabungan',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30.0),
              Text(
                "Pocket Planner Form",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: Colors.white),
                decoration: _buildInputDecoration('Title', Icons.title),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _targetAmountController,
                style: TextStyle(color: Colors.white),
                decoration: _buildInputDecoration('Target Amount', Icons.monetization_on),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _startDateController,
                style: TextStyle(color: Colors.white),
                decoration: _buildInputDecoration('Start Date', Icons.calendar_today),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.white),
                decoration: _buildInputDecoration('Description', Icons.description),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      fillColor: Colors.green.shade700,
      filled: true,
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
