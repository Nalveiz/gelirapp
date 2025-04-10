class TransactionModel {
  final String? id;
  final String type;
  final String category;
  final String description;
  final double amount;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.type, 
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  static TransactionModel fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      type: map['type'],
      category: map['category'],
      description: map['description'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
