import 'dart:html';

import 'package:pocket_planner/screen/dashboard.dart';
import 'package:pocket_planner/services/auth_service.dart';
import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:flutter/material.dart';
//ignore_for_file: prefer_const_constructors

class FormPengisian extends StatefulWidget {
  FormPengisian({super.key});

  @override
  State<FormPengisian> createState() => _FormPengisianState();
}

class _FormPengisianState extends State<FormPengisian> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  var authService = AuthService();
  var isloader = false;

  Future<void> _submitForm() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        isloader = true;
      });

      var data ={
        "username": _userNameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "password": _passwordController.text,
      };

      await authService.createUser(data, context);
      setState(() {
        isloader = false;
      });

      // ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
      //   const SnackBar(content: Text('Form Submitted successfully')),
      // );
    }
  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //tombol back
      //ganti backgrouuund?
      backgroundColor: Color(0xFF2526634),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
          children: [
            const SizedBox(height: 30.0,),
            const SizedBox(
              width: 250,
              child: Text(
              "Pocket Planner Form", 
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 28, 
                fontWeight: FontWeight.bold),)  
              ),
            const SizedBox(height: 30.0,),
            
            TextFormField(
              controller: _userNameController,
              style: TextStyle(color: Colors.white),
              // keyboardType: TextInputType.emailAddress, //ini keyboard uuntuuk isi email
              autovalidateMode: AutovalidateMode.onUserInteraction, //ini validasiny jalan saat user interaksi/input data tapi harus show dluuan validasiny
              decoration: _buildInputDecoration("username", Icons.person),
              validator: appValidator.validateUsename,
            ),
            SizedBox(height: 16.0,),
            TextFormField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("email", Icons.phone),
              validator: appValidator.validateEmail,
              
            ),
            SizedBox(height: 16.0,),
            TextFormField(
              controller: _phoneController,
              style: TextStyle(color: Colors.white),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("phone", Icons.phone),
              validator: appValidator.validatePhoneNumber,
            ),
            SizedBox(height: 16.0,),
              TextFormField(
              controller: _passwordController,
              style: TextStyle(color: Colors.white),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("password", Icons.phone),
              
            ),
            SizedBox(height: 16.0,),
            SizedBox(height: 40.0,),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber
                ),
                onPressed: () {
                   isloader ? print("Loading"): _submitForm();
                },
                child: isloader ? Center(child: CircularProgressIndicator()):
                 Text("Create", style: TextStyle(fontSize: 20)))),
                SizedBox(height: 20.0,),
            TextButton(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
              }, 
              child:   Text(
              "Next Page",
              style: TextStyle(color: Color(0xFFFF123F), fontSize: 20),
            )),
          ],),),
      )
    );
  }

  //global component
  InputDecoration _buildInputDecoration(String label, IconData suffixIcon){
    return InputDecoration(
                fillColor: Color(0xAA494A59),
                // fill color dan filled buat ganti warna dalam form
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0x35949494))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
                filled: true,
                labelStyle: TextStyle(color: Color(0xFFFFFFFF)),
                labelText: label, 
                suffixIcon: Icon(suffixIcon, color: Color(0xFF949424),), //icon dibagian kanan form
                border: OutlineInputBorder( //suffixIcon bikin icon di bagian kanan form pengisian
                borderRadius: BorderRadius.circular(10.0)));
  }
}