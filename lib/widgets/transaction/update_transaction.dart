import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:pocket_planner/utils/format.dart';
import 'package:pocket_planner/utils/global_input.dart';

class UpdateTransactionForm extends StatefulWidget {
  final String userId;
  final dynamic transactionData;
  final Function(dynamic) onUpdate;

  const UpdateTransactionForm({Key? key, required this.userId, required this.transactionData, required this.onUpdate}) : super(key: key);

  @override
  State<UpdateTransactionForm> createState() => _UpdateTransactionFormState();
}

class _UpdateTransactionFormState extends State<UpdateTransactionForm> {
  late String type;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var categoryController = TextEditingController();
  var dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    amountEditController.text = _formatAmount(widget.transactionData['amount'].toString());
    titleEditController.text = widget.transactionData['title'];
    categoryController.text = widget.transactionData['category'];
    type = widget.transactionData['type'];
  // Convert the stored date to DateTime if it's in milliseconds since epoch
  DateTime storedDate = DateTime.fromMillisecondsSinceEpoch(widget.transactionData['dateTime']);
  
  // Format the stored DateTime to your desired format (e.g., "dd/MM/yyyy")
  dateController.text = getDateFormatter().format(storedDate);
  // Add a listener to format the amount dynamically
  amountEditController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    amountEditController.removeListener(_onAmountChanged);
    amountEditController.dispose();
    titleEditController.dispose();
    dateController.dispose(); // Add this line
    categoryController.dispose();
    super.dispose();
  }

  String _formatAmount(String amount) {
    if (amount.isEmpty) return '';

    String digits = amount.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return '';

    final formatter = getCurrencyFormatter(); // Use global formatter
    return formatter.format(int.parse(digits));
  }
  void _onAmountChanged() {
  String formattedAmount = _formatAmount(amountEditController.text);
  amountEditController.value = amountEditController.value.copyWith(
    text: formattedAmount,
    selection: TextSelection.collapsed(offset: formattedAmount.length),
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
      // Format the selected date and update the controller
      dateController.text = getDateFormatter().format(selectedDate!);
    });
  }
}

  Future<void> _updateTransaction(String userId) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      if (userDoc.exists) {
        String amountText = amountEditController.text.replaceAll(RegExp(r'[Rp,. ]'), '');
        var newAmount = int.parse(amountText);
        
        DateTime now = DateTime.now();

        int millisecondsSinceEpoch = now.millisecondsSinceEpoch;

        int remainingAmount = userDoc['remainingAmount'];
        int totalCredit = userDoc['totalCredit'];
        int totalDebit = userDoc['totalDebit'];

        int oldAmount = widget.transactionData['amount'];
        var oldType = widget.transactionData['type'];

        String category = categoryController.text.toLowerCase().trim();

        // Adjust totals by subtracting the old amount
        if (oldType == 'credit') {
          remainingAmount -= oldAmount;
          totalCredit -= oldAmount;
        } else {
          remainingAmount += oldAmount;
          totalDebit -= oldAmount;
        }

        // Adjust totals by adding the new amount
        if (type == 'credit') {
          remainingAmount += newAmount;
          totalCredit += newAmount;
        } else {
          remainingAmount -= newAmount;
          totalDebit += newAmount;
        }

        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          "remainingAmount": remainingAmount,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "updatedAt": millisecondsSinceEpoch,
        });
        // Get the existing createdAt value from the transaction data
        var existingCreatedAt = widget.transactionData['createdAt'];

        var data = {
          "title": titleEditController.text,
          "amount": newAmount,
          "category": category,
          "type": type,
          "dateTime": selectedDate?.millisecondsSinceEpoch ?? millisecondsSinceEpoch, // Update this line
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "remainingAmount": remainingAmount,
          "updatedAt": millisecondsSinceEpoch,
          "createdAt": existingCreatedAt
          };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection("transaction")
            .doc(widget.transactionData['id'])
            .update(data);

        setState(() {
          isLoader = false;
        });

        widget.onUpdate(data);
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction updated successfully')),
      );

        Navigator.pop(context);
      }
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
          'Update Transaction',
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
                controller: titleEditController,
                validator: appValidator.isEmptyCheck,
              ),
              SizedBox(height: 10),
              buildInputRow(
                label: 'Amount',
                icon: Icons.monetization_on,
                controller: amountEditController,
                validator: appValidator.validateAmount,
                isAmount: true,
              ),
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
                    _updateTransaction(widget.userId);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900, // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
                child: isLoader
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                        "Update Transaction",
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
