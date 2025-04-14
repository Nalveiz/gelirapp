import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/expense.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Yeni veri ekleme (kullanıcının UID'si otomatik set edilir)
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

  /// Belirli bir ID'ye sahip işlemi siler
  Future<void> deleteTransaction(String id) async {
    await _db.collection('transactions').doc(id).delete();
  }

  /// Mevcut işlemi günceller
  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id!.isEmpty) return;
    await _db.collection('transactions').doc(transaction.id).update(transaction.toMap());
  }

  /// Sadece giriş yapan kullanıcının işlemlerini döndürür
  Stream<List<TransactionModel>> getTransactions(String userId) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty(); // Kullanıcı oturum açmadıysa boş stream döner
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
