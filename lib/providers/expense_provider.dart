import 'package:flutter/material.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/services/firestore_service.dart';

class TransactionProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  /// Gerçek zamanlı Firestore verisini dinle
  void listenToTransactions(String userId) {
    _firestoreService.getTransactions(userId).listen((data) {
      _transactions = data;
      notifyListeners();
    });
  }

  /// Yeni işlem ekle
  Future<void> addTransaction(TransactionModel transaction) async {
    await _firestoreService.addTransaction(transaction);
  }

  /// İşlem sil
  Future<void> deleteTransaction(String id) async {
    await _firestoreService.deleteTransaction(id);
  }

  /// İşlem güncelle
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _firestoreService.updateTransaction(transaction);
  }

  /// Gerekirse listeyi manuel olarak yenile
  Future<void> refresh(String userId) async {
    final data = await _firestoreService.getTransactions(userId).first;
    _transactions = data;
    notifyListeners();
  }

}
