import 'package:flutter/material.dart';
import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:pocket_planner/widgets/category_dropdown.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: sort_child_properties_last

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = "credit";
  var category = "Grocery";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = AppValidator();
  Future<void> _submitForm() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoader = true;
      });

      // var data ={
      //   "username": _userNameController.text,
      //   "email": _emailController.text,
      //   "phone": _phoneController.text,
      //   "password": _passwordController.text,
      // };

      // await authService.createUser(data, context);
      // setState(() {
      //   isLoader = false;
      // });
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
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
            _submitForm();
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