import 'package:flutter/material.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/services/firestore_service.dart';

class TransactionProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void listenToTransactions(String userId) {
    _firestoreService.getTransactions(userId).listen((data) {
      _transactions = data;
      notifyListeners();
    });
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _firestoreService.addTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _firestoreService.deleteTransaction(id);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _firestoreService.updateTransaction(transaction);
  }

  Future<void> refresh(String userId) async {
    final data = await _firestoreService.getTransactions(userId).first;
    _transactions = data;
    notifyListeners();
  }

}
