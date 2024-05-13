import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/icons_list.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables

// ignore: must_be_immutable
class TransactionCard extends StatelessWidget {
 TransactionCard({
    super.key, required this.data,
  });
  final dynamic data;

  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {

    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    String formattedDate = DateFormat('d MMM hh:mma').format(date);
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
               ],
                border: Border.all(
                      color: Colors.black.withOpacity(0.2), // Set border color to black
                      width: 2, // Set border width
                ),
               ),
          
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
                color: data['type'] == 'credit' 
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
              ),
              child: Center(child: FaIcon(
                appIcons.getExpenseCategoryIcons('${data['category']}'),
                color: data['type'] == 'credit'
                ? Colors.green
                : Colors.red,
                )
              ),
             ),
          ),
          title: Row(
            children: [
            Expanded(
                child: Text(
                  '${data['title']}',
                  style: TextStyle(
                    fontSize: 16, // Adjust font size
                    fontWeight: FontWeight.w500, // Adjust font weight
                    color: Colors.black, // Adjust text color
                  ),
                ),
              ),
            Text("${data['type'] == 'credit' ? '+' : '-'}  Rp ${data['amount']}",
             style: TextStyle(color: data['type'] == 'credit'
                ? Colors.green
                : Colors.red),
                ),
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
              Text("Rp ${data['remainingAmount']}", style: TextStyle(color: Colors.grey, fontSize: 13))
            ],),
              Text(
                formattedDate,
                 style: TextStyle(color: Colors.grey),)
          ],
          ),
        ),
      ),
    );
  }
}