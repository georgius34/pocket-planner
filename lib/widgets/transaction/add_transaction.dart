import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:pocket_planner/utils/format.dart';
import 'package:pocket_planner/utils/global_input.dart';
import 'package:uuid/uuid.dart';

class AddTransactionForm extends StatefulWidget {
  final String userId;

  const AddTransactionForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = "credit";
  var categoryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = AppValidator();
  var amountController = TextEditingController();
  var titleController = TextEditingController();
  var dateController = TextEditingController(); // Add this line
  DateTime? selectedDate; // Add this line
  var uid = Uuid();

  @override
  void initState() {
    super.initState();
    amountController.addListener(_formatAmount);
  }

  @override
  void dispose() {
    amountController.removeListener(_formatAmount);
    amountController.dispose();
    titleController.dispose();
    dateController.dispose(); // Add this line
    categoryController.dispose();
    super.dispose();
  }

  void _formatAmount() {
    String currentText = amountController.text;
    if (currentText.isEmpty) return;

    String digits = currentText.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return;

    final formatter = getCurrencyFormatter(); // Use global formatter
    String formatted = formatter.format(int.parse(digits));

    amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

   // Add this method to show the date picker
  void _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = getDateFormatter().format(selectedDate!); // Update this line
      });
    }
  }

  Future<void> _submitForm(String userId) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      String amountText = amountController.text.replaceAll(RegExp(r'[Rp,. ]'), '');
      var amount = int.parse(amountText);
      var id = uid.v4();

      DateTime now = DateTime.now();
      int millisecondsSinceEpoch = now.millisecondsSinceEpoch;

      int remainingAmount = userDoc['remainingAmount'];
      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];

      String category = categoryController.text.toLowerCase().trim();

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
        "updatedAt": millisecondsSinceEpoch,
      });

      var data = {
        "id": id,
        "title": titleController.text,
        "amount": amount,
        "category": category,
        "type": type,
        "dateTime": selectedDate?.millisecondsSinceEpoch ?? millisecondsSinceEpoch, // Update this line
        "createdAt": millisecondsSinceEpoch,
        "updatedAt": millisecondsSinceEpoch,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "remainingAmount": remainingAmount
      };

      await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection("transaction").doc(id).set(data);

      amountController.clear();
      titleController.clear();
      dateController.clear(); // Add this line

      setState(() {
        isLoader = false;
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaction added successfully')),
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
          'Add Transaction',
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
              SizedBox(height: 10),
            buildInputRow(
                label: 'Amount',
                icon: Icons.monetization_on,
                controller: amountController,
                validator: appValidator.validateAmount,
                isAmount: true,
              ),
              SizedBox(height: 10),
              // Add the date picker input row here
              buildDateInputRow(
                label: 'Date',
                icon: Icons.calendar_today,
                controller: dateController,
                onTap: () => _pickDate(context),
                validator: appValidator.isEmptyCheck,
              ),
              SizedBox(height: 10),
               buildInputRow(
                label: 'Category',
                icon: Icons.category,
                controller: categoryController,
                validator: appValidator.isEmptyCheck,
              ),
              SizedBox(height: 10),
               buildTypeDropDownInput(
                label: 'Type',
                type: type,
                onChanged: (value) {
                  setState(() {
                    type = value!;
                  });
                },
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (!isLoader) {
                    _submitForm(widget.userId);
                  }
                },
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900, // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
                child: isLoader
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                        "Add Transaction",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
