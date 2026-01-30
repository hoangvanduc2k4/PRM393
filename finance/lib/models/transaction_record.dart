class TransactionRecord {
  final int? id;
  final String type; // 'IMPORT' or 'EXPORT'
  final int itemId; // Foreign key to MaterialItem or ProductItem
  final String itemType; // 'MATERIAL' or 'PRODUCT'
  final int quantity;
  final double price; // Price per unit at the time of transaction
  final String partnerName; // Supplier or Customer
  final DateTime date;

  TransactionRecord({
    this.id,
    required this.type,
    required this.itemId,
    required this.itemType,
    required this.quantity,
    required this.price,
    required this.partnerName,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'item_id': itemId,
      'item_type': itemType,
      'quantity': quantity,
      'price': price,
      'partner_name': partnerName,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionRecord.fromMap(Map<String, dynamic> map) {
    return TransactionRecord(
      id: map['id'],
      type: map['type'],
      itemId: map['item_id'],
      itemType: map['item_type'],
      quantity: map['quantity'],
      price: map['price'],
      partnerName: map['partner_name'],
      date: DateTime.parse(map['date']),
    );
  }
}
