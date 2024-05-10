import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_planner/widgets/add_rencana_tabungan.dart';
import 'package:pocket_planner/widgets/rencana_tab.dart';
import 'package:pocket_planner/widgets/rencana_tabungan_card.dart';

class RencanaTabunganScreen extends StatelessWidget {
  final String userId;

  RencanaTabunganScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text(
          'Rencana Tabungan',
          style: TextStyle(color: Colors.white),
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
                    child: Text('Tambah Rencana'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('rencanaTabungan')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final data = snapshot.data!.docs.map((doc) {
                    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    return RencanaTabungan(
                      title: data['title'],
                      targetAmount: data['targetAmount'],
                      startDate: data['startDate'],
                      description: data['description'],
                    );
                  }).toList();

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final rencana = data[index];
                      return RencanaTabunganCard(
                        title: rencana.title,
                        targetAmount: rencana.targetAmount,
                        startDate: rencana.startDate,
                        description: rencana.description,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
