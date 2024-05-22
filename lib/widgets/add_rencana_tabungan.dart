import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bungaController = TextEditingController();
  int? _selectedPeriode = 1; // Set default value here
  var uid = Uuid();

  var appValidator = AppValidator();

  @override
  void initState() {
    super.initState();
    _targetAmountController.addListener(_formatAmount);
  }

  @override
  void dispose() {
    _targetAmountController.removeListener(_formatAmount);
    _titleController.dispose();
    _targetAmountController.dispose();
    _descriptionController.dispose();
    _bungaController.dispose();
    super.dispose();
  }

  void _formatAmount() {
    String currentText = _targetAmountController.text;
    if (currentText.isEmpty) return;

    String digits = currentText.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return;

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    String formatted = formatter.format(int.parse(digits));

    _targetAmountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _submitForm(String userId) async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      var id = uid.v4();
      String amountText = _targetAmountController.text.replaceAll(RegExp(r'[Rp,. ]'), '');
      double targetAmount = double.parse(amountText);
      double progress = 0;
      double currentAmount = 0;
      int bunga = _bungaController.text.isEmpty ? 0 : int.parse(_bungaController.text);
      int periode = _selectedPeriode ?? 1;

      final startDate = DateTime.now();
      final endDate = DateTime(startDate.year, startDate.month + periode, startDate.day);
      final deadline = endDate.difference(startDate).inDays;

      double tabunganBulanan;
      if (bunga > 0) {
        tabunganBulanan = (targetAmount + (targetAmount * bunga / 100)) / periode;
      } else {
        tabunganBulanan = targetAmount / periode;
      }
      tabunganBulanan = double.parse(tabunganBulanan.toStringAsFixed(2));

      await firestore.collection('users').doc(widget.userId).collection('rencanaTabungan').doc(id).set({
        'id': id,
        'title': _titleController.text,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'progress': progress,
        'startDate': DateFormat('dd/MM/yyyy').format(startDate),
        'endDate': DateFormat('dd/MM/yyyy').format(endDate),
        'deadline': deadline,
        'description': _descriptionController.text,
        'bunga': bunga,
        'periode': periode,
        'tabunganBulanan': tabunganBulanan,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green.shade900,
        title: Text(
          'Tambah Rencana Tabungan',
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
              _buildInputRow('Title', Icons.title, _titleController, appValidator.isEmptyCheck),
              SizedBox(height: 10.0),
              _buildInputRow('Target Amount', Icons.monetization_on, _targetAmountController, appValidator.validateAmount, isCurrency: true),
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
                validator: (value) {
                  if (value == null) {
                    return 'Please select a period';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              _buildInputRow('Description', Icons.description, _descriptionController, null),
              SizedBox(height: 10.0),
              _buildInputRow('Bunga (Optional)', Icons.monetization_on, _bungaController, null),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm(widget.userId);
                },
                child: Text('Submit', style: TextStyle(color: Colors.green.shade600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, IconData icon, TextEditingController controller, String? Function(String?)? validator, {bool isCurrency = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2),
        TextFormField(
          controller: controller,
          keyboardType: isCurrency ? TextInputType.number : TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2),
        DropdownButtonFormField<int>(
          value: value,
          icon: null,
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
