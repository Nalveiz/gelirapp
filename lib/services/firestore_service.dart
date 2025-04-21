import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/expense.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTransaction(TransactionModel transaction) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final transactionWithUser = TransactionModel(
      id: transaction.id,
      userId: uid,
      type: transaction.type,
      category: transaction.category,
      description: transaction.description,
      amount: transaction.amount,
      date: transaction.date,
    );

    await _db.collection('transactions').add(transactionWithUser.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    await _db.collection('transactions').doc(id).delete();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id!.isEmpty) return;
    await _db.collection('transactions').doc(transaction.id).update(transaction.toMap());
  }

  Stream<List<TransactionModel>> getTransactions(String userId) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty(); 
    }

    return _db
        .collection('transactions')
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
