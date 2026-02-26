class ProductionLogModel {
  final String id;
  final String productId;
  final int quantityProduced;
  final DateTime productionDate;

  ProductionLogModel({
    required this.id,
    required this.productId,
    required this.quantityProduced,
    required this.productionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity_produced': quantityProduced,
      'production_date': productionDate.toIso8601String(),
    };
  }

  factory ProductionLogModel.fromMap(Map<String, dynamic> map) {
    return ProductionLogModel(
      id: map['id'],
      productId: map['product_id'],
      quantityProduced: map['quantity_produced'],
      productionDate: DateTime.parse(map['production_date']),
    );
  }
}
