import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:pocket_planner/widgets/category_dropdown.dart';

class UpdateTransactionForm extends StatefulWidget {
  final String userId;
  final dynamic transactionData;

  const UpdateTransactionForm({Key? key, required this.userId, required this.transactionData}) : super(key: key);

  @override
  State<UpdateTransactionForm> createState() => _UpdateTransactionFormState();
}

class _UpdateTransactionFormState extends State<UpdateTransactionForm> {
  var type = "credit";
  late String category;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountEditController.text = widget.transactionData['amount'].toString();
    titleEditController.text = widget.transactionData['title'];
    category = widget.transactionData['category'];
    type = widget.transactionData['type'];
  }

  Future<void> _updateTransaction(String userId) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      if (userDoc.exists) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        var amount = int.parse(amountEditController.text);
        DateTime date = DateTime.now();

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

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection("transaction")
            .doc(widget.transactionData['id'])
            .update(data);

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
              _buildInputRow('Title', Icons.title, titleEditController),
              SizedBox(height: 10),
              _buildInputRow('Amount', Icons.monetization_on, amountEditController),
              SizedBox(height: 10),
              _buildCategoryDropDownInput('Category', Icons.category),
              SizedBox(height: 10),
              _buildTypeDropDownInput('type'),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (!isLoader) {
                    _updateTransaction(widget.userId);
                  }
                },
                child: isLoader
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                        "Update Transaction",
                        style: TextStyle(color: Colors.green),
                      ),
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: appValidator.isEmptyCheck,
          keyboardType: label == 'Amount' ? TextInputType.number : TextInputType.text,
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

  // Fungsi untuk membangun dropdown input kategori
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

  // Fungsi untuk membangun dropdown input kategori
  Widget _buildTypeDropDownInput(String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
      ),
      SizedBox(height: 2), // Adjust vertical spacing
      SizedBox(
        height: 60, // Adjust height
        child: DropdownButtonFormField(
          value: type,
          items: [
            DropdownMenuItem(
              child: Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.green), // Icon untuk Credit
                  SizedBox(width: 10),
                  Text('Credit', style: TextStyle(color: Colors.green)), // Ubah warna teks untuk opsi Credit
                ],
              ),
              value: 'credit',
            ),
            DropdownMenuItem(
              child: Row(
                children: [
                  Icon(Icons.money_off, color: Colors.red), // Icon untuk Debit
                  SizedBox(width: 10),
                  Text('Debit', style: TextStyle(color: Colors.red)), // Ubah warna teks untuk opsi Debit
                ],
              ),
              value: 'debit',
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                type = value.toString();
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
