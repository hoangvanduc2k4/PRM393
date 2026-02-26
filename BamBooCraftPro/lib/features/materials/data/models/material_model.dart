class MaterialModel {
  final String id;
  final String name;
  final String unit;
  final double quantityAvailable;
  final DateTime lastUpdated;

  MaterialModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantityAvailable,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'quantity_available': quantityAvailable,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      quantityAvailable: map['quantity_available'],
      lastUpdated: DateTime.parse(map['last_updated']),
    );
  }
}
