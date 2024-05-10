import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteTransaction(String userId, String transactionId, int amount, String type) async {
    try {
      // Retrieve the current user document
      var userDoc = await _firestore.collection('users').doc(userId).get();

      // Retrieve the current values of totalCredit, totalDebit, and remainingAmount
      int totalCredit = userDoc['totalCredit'] as int;
      int totalDebit = userDoc['totalDebit'] as int;
      int remainingAmount = userDoc['remainingAmount'] as int;

      // Update totalCredit and totalDebit based on the type of transaction
      if (type == 'credit') {
        totalCredit -= amount;
      } else {
        totalDebit -= amount;
      }

      // Update remainingAmount based on the type of transaction
      remainingAmount += (type == 'credit') ? -amount : amount;

      // Update the user document in Firestore with the new values
      await _firestore.collection('users').doc(userId).update({
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "remainingAmount": remainingAmount,
      });

      // Delete transaction from Firestore
      await _firestore.collection('users').doc(userId).collection("transaction").doc(transactionId).delete();
    } catch (e) {
      // Throw an error or handle it appropriately
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
