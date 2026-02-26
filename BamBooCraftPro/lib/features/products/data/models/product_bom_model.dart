class ProductBomModel {
  final String id;
  final String productId;
  final String materialId;
  final double quantityRequired;

  ProductBomModel({
    required this.id,
    required this.productId,
    required this.materialId,
    required this.quantityRequired,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'material_id': materialId,
      'quantity_required': quantityRequired,
    };
  }

  factory ProductBomModel.fromMap(Map<String, dynamic> map) {
    return ProductBomModel(
      id: map['id'],
      productId: map['product_id'],
      materialId: map['material_id'],
      quantityRequired: map['quantity_required'],
    );
  }
}
