class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final DateTime date;
  final String? description;
  final String? referenceId;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
    this.referenceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'reference_id': referenceId,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      description: map['description'],
      referenceId: map['reference_id'],
    );
  }
}
