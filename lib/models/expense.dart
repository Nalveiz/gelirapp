import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String? id;
  final String userId;
  final String type;
  final String category;
  final String description;
  final double amount;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: (map['date'] is Timestamp)
          ? (map['date'] as Timestamp).toDate()
          : DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'category': category,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }
}

