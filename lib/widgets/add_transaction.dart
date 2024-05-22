import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:pocket_planner/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';

class AddTransactionForm extends StatefulWidget {
  final String userId;

  const AddTransactionForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = "credit";
  var category = "Grocery";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  @override
  void initState() {
    super.initState();
    amountEditController.addListener(_formatAmount);
  }

  @override
  void dispose() {
    amountEditController.removeListener(_formatAmount);
    amountEditController.dispose();
    titleEditController.dispose();
    super.dispose();
  }

  void _formatAmount() {
    String currentText = amountEditController.text;
    if (currentText.isEmpty) return;

    String digits = currentText.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return;

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    String formatted = formatter.format(int.parse(digits));

    amountEditController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _submitForm(String userId) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      if (userDoc.exists) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        String amountText = amountEditController.text.replaceAll(RegExp(r'[Rp,. ]'), '');
        var amount = int.parse(amountText);
        DateTime date = DateTime.now();

        var id = uid.v4();
        String monthYear = DateFormat('MMM y').format(date);

        int remainingAmount = userDoc['remainingAmount'];
        int totalCredit = userDoc['totalCredit'];
        int totalDebit = userDoc['totalDebit'];

        if (type == 'credit') {
          remainingAmount += amount;
          totalCredit += amount;
        } else {
          remainingAmount -= amount;
          totalDebit += amount;
        }

        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          "remainingAmount": remainingAmount,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "updatedAt": timestamp,
        });

        var data = {
          "id": id,
          "title": titleEditController.text,
          "amount": amount,
          "type": type,
          "timestamp": timestamp,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "remainingAmount": remainingAmount,
          "monthyear": monthYear,
          "category": category
        };

        await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection("transaction").doc(id).set(data);

        amountEditController.clear();
        titleEditController.clear();

        setState(() {
          isLoader = false;
        });

        Navigator.pop(context);
      }
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
          'Tambah Transaksi',
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
              _buildInputRow('Title', Icons.title, titleEditController, appValidator.isEmptyCheck),
              SizedBox(height: 10),
              _buildInputRow('Amount', Icons.monetization_on, amountEditController, appValidator.validateAmount, isAmount: true),
              SizedBox(height: 10),
              _buildCategoryDropDownInput('Category', Icons.category),
              SizedBox(height: 10),
              _buildTypeDropDownInput('type'),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (!isLoader) {
                    _submitForm(widget.userId);
                  }
                },
                child: isLoader
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                        "Tambah Transaksi",
                        style: TextStyle(color: Colors.green),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, IconData icon, TextEditingController controller, String? Function(String?)? validator, {bool isAmount = false}) {
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          keyboardType: isAmount ? TextInputType.number : TextInputType.text,
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

  Widget _buildCategoryDropDownInput(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        CategoryDropDown(
          cattype: category,
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                category = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildTypeDropDownInput(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2),
        SizedBox(
          height: 60,
          child: DropdownButtonFormField(
            value: 'credit',
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.green),
                    SizedBox(width: 10),
                    Text('Credit', style: TextStyle(color: Colors.green)),
                  ],
                ),
                value: 'credit',
              ),
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.money_off, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Debit', style: TextStyle(color: Colors.red)),
                  ],
                ),
                value: 'debit',
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  type = value;
                });
              }
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
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
          ),
        ),
      ],
    );
  }
}
