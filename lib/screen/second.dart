import 'dart:html';

import 'package:pocket_planner/utils/appvalidators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//ignore_for_file: prefer_const_constructors

class SecondView extends StatelessWidget {
  SecondView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Form Submitted successfully')),
      );
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
              "Second Page", 
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 28, 
                fontWeight: FontWeight.bold),)  
              ),
            const SizedBox(height: 30.0,),
            
            TextFormField(
              style: TextStyle(color: Colors.white),
              // keyboardType: TextInputType.emailAddress, //ini keyboard uuntuuk isi email
              autovalidateMode: AutovalidateMode.onUserInteraction, //ini validasiny jalan saat user interaksi/input data tapi harus show dluuan validasiny
              decoration: _buildInputDecoration("Input1", Icons.person),
              validator: appValidator.validateUsename,
            ),
            SizedBox(height: 16.0,),
            TextFormField(
              style: TextStyle(color: Colors.white),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("Input2", Icons.phone),
              validator: appValidator.validateUsename,
              
            ),
            SizedBox(height: 16.0,),
            TextFormField(
              style: TextStyle(color: Colors.white),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("Input3", Icons.phone),
              validator: appValidator.validateUsename,
            ),
            SizedBox(height: 40.0,),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber
                ),
                onPressed: _submitForm, child: Text("Create", style: TextStyle(fontSize: 20)))),
                SizedBox(height: 20.0,),
            TextButton(
              onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const SecondRoute()),
              // );
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