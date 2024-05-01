import 'package:cloud_firestore/cloud_firestore.dart';

class Db{
  CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void> addUser() {
  return users
    .doc('ABC123')
    .set({
      'full_name': "Mary Jane",
      'age': 18
    })
    .then((value) => print("User Added"))
    .catchError((error) => print("Failed to add user: $error"));
}
}