// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_planner/screen/dashboard.dart';
import 'package:pocket_planner/widgets/add_progress.dart';

class RencanaTabunganDetailScreen extends StatelessWidget {
  final String userId;
  final dynamic rencanaData;

   RencanaTabunganDetailScreen({
    required this.userId,
    required this.rencanaData,
  });

Future<String> _getRencanaTabunganId() async {
  // Mengambil ID dari rencana tabungan dari rencanaData
  String rencanaTabunganId = rencanaData['id'];
  
  // Mengembalikan ID rencana tabungan
  return rencanaTabunganId;
}

void _deleteTransaction(BuildContext context) async {
  try {
    // Mendapatkan ID rencana tabungan sesuai dengan indeks yang diklik

    // Menghapus transaksi dari database
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("rencanaTabungan")
        .doc(rencanaData['id'])
        .delete();

    // Kembali ke halaman dashboard dan pilih pilihan kedua pada NavBar
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Dashboard(userId: userId),
      ),
      (route) => false, // Menghapus semua halaman sebelumnya dari tumpukan navigasi
    ).then((_) {
      // Setelah halaman Dashboard dimuat, kita akan memilih pilihan kedua pada NavBar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            userId: userId,
            initialIndex: 1, // Memilih pilihan kedua pada NavBar
          ),
        ),
      );
    });
  } catch (e) {
    // Menampilkan pesan error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete transaction')),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Transaction'),
        content: Text('Are you sure you want to delete this transaction?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => _deleteTransaction(context), // Pass index to _deleteTransaction
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}




  @override
  Widget build(BuildContext context) {
    final String title = rencanaData['title'];
    final double targetAmount = rencanaData['targetAmount'];
    final double currentAmount = rencanaData['currentAmount'];
    final String startDate = rencanaData['startDate'];
    final String endDate = rencanaData['endDate'];
    final String description = rencanaData['description'];
    final int deadline = rencanaData['deadline'];
    final double progress = rencanaData['progress'];
    final double bunga = rencanaData['bunga'];


    return Scaffold(
          appBar: AppBar(
            title: Text(
              'Detail',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            backgroundColor: Colors.green.shade900,
            iconTheme: IconThemeData(color: Colors.white), // Mengatur warna ikon back button
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmationDialog(context),
              ),
            ],
          ),
      body: SingleChildScrollView(
        child: Container(
              decoration: BoxDecoration(
                // color: Colors.green.shade900, // Set opacity to achieve the blurred effect
              ),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CircularProgressIndicator for semi-circle progress display
               Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 1.0,
                        spreadRadius: 1.5,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                        minHeight: 30,
                        semanticsLabel: 'Progress Indicator',
                      ),
                      SizedBox(height: 10),
                      Container(
                      child: SizedBox(
                        width: 400,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Tabungan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        Text(
                          'Rp ${currentAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 1.0,
                        spreadRadius: 1.5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left data
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 30,
                                color: Colors.green.shade600,
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tenggat Waktu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    '${deadline} hari',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Container(
                            height: 30,
                            child: VerticalDivider(
                              color: Colors.grey.shade500,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      // Right data (Progress)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.stacked_line_chart_outlined,
                                size: 30,
                                color: Colors.green.shade600,
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Progress',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    '${progress.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Add "Detail Data" Text and "Add Progress" Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Rencana',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: Colors.green.shade900,
                      ),
                    ),
            ElevatedButton(
                  onPressed: () async {
                    String rencanaTabunganId = await _getRencanaTabunganId();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddProgressPopUp(
                              rencanaTabunganId: rencanaTabunganId,
                              rencanaData: rencanaData, // Tambahkan nilai totalAmount
                              userId: userId,
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Ubah warna latar belakang tombol di sini
                  ),
                  child: Text('Add Tabungan'),
                ),
                  ],
                ),
                SizedBox(height: 10), // Add some spacing between the row and the detail boxes

                // Additional Information
                _buildDetailBox('Title', title),
                _buildDetailBox('Target Amount', 'Rp ${targetAmount.toStringAsFixed(2)}'),
                _buildDetailBox('Current Amount', 'Rp ${currentAmount.toStringAsFixed(2)}'),
                _buildDetailBox('Start Date', startDate),
                _buildDetailBox('End Date', endDate), // Display end date
                _buildDetailBox('Description', description),
                _buildDetailBox('Bunga', bunga.toStringAsFixed(2)), // Display bunga
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, String $value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4.0), // Reduced vertical margin
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), // Reduced padding to make the box smaller
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2), // Adjusted offset to reduce shadow height
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 1.0,
            spreadRadius: 1.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14, // Adjusted font size
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 4.0), // Added space between label and text
          Text(
            $value,
            style: TextStyle(fontSize: 16, color: Colors.black), // Adjusted font size
          ),
        ],
      ),
    );
  }
}
