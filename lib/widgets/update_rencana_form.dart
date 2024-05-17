import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class _DropdownInputRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int? value;
  final ValueChanged<int?> onChanged;
  final List<int> options;

  const _DropdownInputRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2), // Adjust vertical spacing
        DropdownButtonFormField<int>(
          value: value,
          icon: null, // Set icon to null to remove the default dropdown icon
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
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString(), style: TextStyle(color: Colors.green.shade600)),
            );
          }).toList(),
          isExpanded: true,
          dropdownColor: Colors.white,
        ),
      ],
    );
  }
}


class UpdateRencanaTabunganForm extends StatefulWidget {
  final String userId;
  final dynamic rencanaData;

  UpdateRencanaTabunganForm({
    required this.userId,
    required this.rencanaData, required String rencanaTabunganId, required void Function(double newAmount) refreshData,
  });

  @override
  _UpdateRencanaTabunganFormState createState() => _UpdateRencanaTabunganFormState();
}

class _UpdateRencanaTabunganFormState extends State<UpdateRencanaTabunganForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bungaController = TextEditingController(); // New field for bunga (interest rate)
  int? _selectedPeriode;

  late dynamic _rencanaData;

  @override
  void initState() {
    super.initState();
    _rencanaData = widget.rencanaData;

    _titleController.text = _rencanaData['title'];
    _targetAmountController.text = _rencanaData['targetAmount'].toString();
    _descriptionController.text = _rencanaData['description'];
    _bungaController.text = _rencanaData['bunga'].toString();
    _selectedPeriode = _rencanaData['periode'];
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      double targetAmount = double.parse(_targetAmountController.text);
      int bunga = _bungaController.text.isEmpty ? 0 : int.parse(_bungaController.text);
      int periode = _selectedPeriode ?? 1;

      // Calculate start and end dates
      final startDate = DateTime.now(); // Start date is today's date
      final endDate = DateTime(startDate.year, startDate.month + periode, startDate.day);
      final deadline = endDate.difference(startDate).inDays; // Calculate deadline

      // Calculate tabungan bulanan
      double tabunganBulanan;
      if (bunga > 0) {
        tabunganBulanan = (targetAmount + (targetAmount * bunga / 100)) / periode;
      } else {
        tabunganBulanan = targetAmount / periode;
      }
      tabunganBulanan = double.parse(tabunganBulanan.toStringAsFixed(2));

      await firestore.collection('users').doc(widget.userId).collection('rencanaTabungan').doc(_rencanaData['id']).update({
        'title': _titleController.text,
        'targetAmount': targetAmount,
        'description': _descriptionController.text,
        'bunga': bunga,
        'periode': periode,
        'endDate': formatter.format(endDate), // Update end date in Firestore
        'deadline': deadline, // Update deadline in Firestore
        'tabunganBulanan': tabunganBulanan, // Update tabungan bulanan in Firestore
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
          'Update Rencana Tabungan',
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
              _DropdownInputRow(
                label: 'Periode (Per Bulan)',
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
              _buildInputRow('Description', Icons.description, _descriptionController),
              SizedBox(height: 10.0),
              _buildInputRow('Bunga (Optional)', Icons.monetization_on, _bungaController),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Update', style: TextStyle(color: Colors.green.shade600)),
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
          keyboardType: label == 'Target Amount' || label == 'Bunga (Optional)' ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: Colors.green.shade600, fontWeight:
FontWeight.w600, wordSpacing: 1.5),
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
