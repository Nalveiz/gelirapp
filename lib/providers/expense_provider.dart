import 'package:flutter/material.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/services/firestore_service.dart';

class TransactionProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  TransactionProvider() {
    _loadTransactions();
  }

  // Veri ekleme
  Future<void> addTransaction(TransactionModel transaction) async {
    await _firestoreService.addTransaction(transaction);
    _transactions.add(transaction); // Listeye ekleme
    notifyListeners();
  }

  // Veri silme
  Future<void> deleteTransaction(String id) async {
    await _firestoreService.deleteTransaction(id);
    _transactions.removeWhere(
      (transaction) => transaction.id == id,
    ); // Listeyi güncelleme
    notifyListeners();
  }

  // Veri güncelleme
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _firestoreService.updateTransaction(transaction);
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction; // Listeyi güncelleme
      notifyListeners();
    }
  }

  // Verileri yükleme
  Future<void> _loadTransactions() async {
    _firestoreService.getTransactions().listen((transactions) {
      _transactions = transactions;
      notifyListeners();
    });
  }
}
