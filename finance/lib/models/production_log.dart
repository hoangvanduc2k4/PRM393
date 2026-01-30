class ProductionLog {
  final int? id;
  final int productId;
  final int quantityProduced;
  final DateTime date;
  final String note;

  ProductionLog({
    this.id,
    required this.productId,
    required this.quantityProduced,
    required this.date,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity_produced': quantityProduced,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory ProductionLog.fromMap(Map<String, dynamic> map) {
    return ProductionLog(
      id: map['id'],
      productId: map['product_id'],
      quantityProduced: map['quantity_produced'],
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }
}
