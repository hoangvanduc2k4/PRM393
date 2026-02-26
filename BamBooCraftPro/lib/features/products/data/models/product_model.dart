class ProductModel {
  final String id;
  final String name;
  final double sellingPrice;
  final String? description;

  ProductModel({
    required this.id,
    required this.name,
    required this.sellingPrice,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'selling_price': sellingPrice,
      'description': description,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      sellingPrice: map['selling_price'],
      description: map['description'],
    );
  }
}
