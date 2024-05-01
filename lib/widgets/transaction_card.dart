import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocket_planner/utils/icons_list.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables

class TransactionCard extends StatelessWidget {
  TransactionCard({super.key});

  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "List Transaksi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              physics: ScrollPhysics(),
              itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8), //padding list datany
                child: Container(
                  decoration: 
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0,10),
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3.0,
                          spreadRadius: 4.0
                          ),
                         ]),
                    
                  child: ListTile(
                    minVerticalPadding: 10, //padding all data
                    contentPadding: 
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    leading: Container(
                         width: 70,
                        height: 100,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green.withOpacity(0.2),
                        ),
                        child: Center(child: FaIcon(appIcons.getExpenseCategoryIcons('home'))),
                       ),
                    ),
                    title: Row(
                      children: [
                      Expanded(child: Text("Gaji harian")),
                      Text("Rp 25000", style: TextStyle(color: Colors.green),),
                      ]
                      ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                        children: [
                        Text("Balance", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Spacer(),
                        Text("Rp 50000", style: TextStyle(color: Colors.grey, fontSize: 13))
                      ],),
                        Text("04 Apr 19:31 PM", style: TextStyle(color: Colors.grey),)
                    ],
                    ),
                  ),
                ),
              );
            })
        ],
      ),
    );
  }
}