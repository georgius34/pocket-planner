import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:pocket_planner/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: sort_child_properties_last

class AddTransactionForm extends StatefulWidget {
  final String userId; // Add userId as a parameter

  const AddTransactionForm({Key? key, required this.userId}) : super(key: key); // Add userId to the constructor

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

 Future<void> _submitForm(String userId) async {

  if(_formKey.currentState!.validate()){
    setState(() {
      isLoader = true;
    });

    // Retrieve the user document using the provided userId
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    // Ensure the user document exists
    if (userDoc.exists) {
      int timestamp = DateTime.now().microsecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
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
        remainingAmount -= amount; // subtract amount for debit
        totalDebit += amount;
      }

      // Update the user document with the new values
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        "remainingAmount": remainingAmount,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "updatedAt": timestamp,
      });

      var data ={
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

      // Add the transaction document under the user's transactions collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection("transaction")
          .doc(id)
          .set(data);

      // Close the form after submitting
      Navigator.pop(context);

      setState(() {
        isLoader = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key:  _formKey,
        // ini isi formny
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField( //klo mw nambah add more text form field
              controller: titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            CategoryDropDown(
              cattype: category,
              
              onChanged: (String? value) {
                if(value !=null){
                  setState(() {
                    category = value;
                  });
                }
                },),
            DropdownButtonFormField(
              value: 'credit', 
              items: [
              DropdownMenuItem(child: Text('Credit'), value: 'credit',),
              DropdownMenuItem(child: Text('Debit'), value: 'debit',),
            ],
             onChanged: (value){
              if (value != null){
                setState(() {
                  type = value;
                });
              }
             }),
          
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
            if(isLoader == false){
            _submitForm(widget.userId);
            }
          },
          child: 
          isLoader ? Center(child: CircularProgressIndicator()):
          Text("Tambah Transaksi"))
          ],
        )
      ),
    );
  }
}