// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_planner/screen/planned_saving/rencana_tabungan_detail_screen.dart';
import 'package:pocket_planner/widgets/planned_saving/add_planned_saving_form.dart';
import 'package:pocket_planner/widgets/planned_saving/planned_saving_card.dart';

class RencanaTabunganScreen extends StatefulWidget {
  final String userId;

  RencanaTabunganScreen({required this.userId, Key? key}) : super(key: key);

  @override
  State<RencanaTabunganScreen> createState() => _RencanaTabunganScreenState();
}

class _RencanaTabunganScreenState extends State<RencanaTabunganScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.green.shade900,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Planned Saving List',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3.0,
                          spreadRadius: 4.0,
                        ),
                      ],
                    ),
                   child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .collection('plannedSaving')
                            .limit(10)
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Something went wrong'));
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          var data = snapshot.data!.docs;

                          if (data.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 50,),
                                  Icon(
                                    Icons.info_outline,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'No Data Found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              var rencana = data[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RencanaTabunganDetailScreen(
                                        userId: widget.userId,
                                        rencanaData: rencana.data(), // Pass rencana object here
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: RencanaTabunganCard(rencanaData: rencana), // Pass rencana object to card
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRencanaTabunganForm(userId: widget.userId),
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
