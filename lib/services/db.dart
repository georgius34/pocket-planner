import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Db {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Generate a unique user ID
  String generateUserId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  Future<String> addUser() async {
    // Generate a unique user ID
    String userId = generateUserId();
    // Get the current date and time in DateTime format
    DateTime now = DateTime.now();

    // Get the current date and time in milliseconds since epoch format
    int millisecondsSinceEpoch = now.millisecondsSinceEpoch;

    // Create a new document in the "users" collection with the generated user ID
    await users
        .doc(userId)
        .set({
          'remainingAmount': 0,
          'totalCredit': 0,
          'totalDebit': 0,
          'createdAt': millisecondsSinceEpoch,
          'updatedAt': millisecondsSinceEpoch,
          // You can add more fields here if needed
        })
        .then((value) => print("User Added with ID: $userId"))
        .catchError((error) => print("Failed to add user: $error"));

    // Return the generated user ID
    return userId;
  }

  
  // Optionally, include other methods as needed for your app
}