class MaterialImportModel {
  final String id;
  final String materialId;
  final String? source;
  final DateTime importDate;
  final double unitPrice;
  final double quantity;
  final double quantityRemaining;
  final double totalCost;

  MaterialImportModel({
    required this.id,
    required this.materialId,
    this.source,
    required this.importDate,
    required this.unitPrice,
    required this.quantity,
    required this.quantityRemaining,
    required this.totalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'material_id': materialId,
      'source': source,
      'import_date': importDate.toIso8601String(),
      'unit_price': unitPrice,
      'quantity': quantity,
      'quantity_remaining': quantityRemaining,
      'total_cost': totalCost,
    };
  }

  factory MaterialImportModel.fromMap(Map<String, dynamic> map) {
    return MaterialImportModel(
      id: map['id'],
      materialId: map['material_id'],
      source: map['source'],
      importDate: DateTime.parse(map['import_date']),
      unitPrice: map['unit_price'],
      quantity: map['quantity'],
      quantityRemaining: map['quantity_remaining'],
      totalCost: map['total_cost'],
    );
  }
}
