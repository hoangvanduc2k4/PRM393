class MaterialItem {
  final int? id;
  final String name;
  final String unit;
  final double quantity; // Changed to double
  final double avgCost; // Average cost per unit

  MaterialItem({
    this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.avgCost,
  });

  // Convert a MaterialItem into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'avg_cost': avgCost,
    };
  }

  // Implement toString to make it easier to see information about
  // each material when using the print statement.
  @override
  String toString() {
    return 'MaterialItem{id: $id, name: $name, unit: $unit, quantity: $quantity, avgCost: $avgCost}';
  }

  factory MaterialItem.fromMap(Map<String, dynamic> map) {
    return MaterialItem(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      quantity: (map['quantity'] as num).toDouble(), // Safely handle int or double from DB
      avgCost: map['avg_cost'],
    );
  }
}
