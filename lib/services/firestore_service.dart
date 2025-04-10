import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/expense.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTransaction(TransactionModel transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    await _db.collection('transactions').doc(id).delete();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id == null) return;
    await _db.collection('transactions').doc(transaction.id).update(transaction.toMap());
  }

  Stream<List<TransactionModel>> getTransactions() {
    return _db.collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }
}
