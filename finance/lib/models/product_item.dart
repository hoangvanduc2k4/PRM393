class ProductItem {
  final int? id;
  final String name;
  final String unit;
  final int quantity;
  final String description;
  final double sellingPrice; // Default selling price

  ProductItem({
    this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    this.description = '',
    this.sellingPrice = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'description': description,
      'selling_price': sellingPrice,
    };
  }

  factory ProductItem.fromMap(Map<String, dynamic> map) {
    return ProductItem(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      quantity: map['quantity'],
      description: map['description'],
      sellingPrice: map['selling_price'],
    );
  }
}
