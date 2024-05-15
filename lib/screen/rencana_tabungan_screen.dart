import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_planner/screen/rencana_tabungan_detail_screen.dart';
import 'package:pocket_planner/widgets/add_rencana_tabungan.dart';
import 'package:pocket_planner/widgets/rencana_tabungan_card.dart';

class RencanaTabunganScreen extends StatelessWidget {
  final String userId;

  RencanaTabunganScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text(
          'Rencana Tabungan',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500, wordSpacing: 1.2),
        ),
      ),
      body: Container(
        color: Colors.green.shade900,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Rencana Tabungan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRencanaTabunganForm(userId: userId),
                        ),
                      );
                    },
                    child: Text(
                      'Tambah Rencana',
                      style: TextStyle(
                        color: Colors.green.shade900, // Set text color to green.shade900
                      ),
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
                        .doc(userId)
                        .collection('rencanaTabungan')
                        .limit(10)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                     var data = snapshot.data!.docs;

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
                                    userId: userId,
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
    );
  }
}
