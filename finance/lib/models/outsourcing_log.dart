class OutsourcingLog {
  final int? id;
  final String workerName;
  final String taskName; // e.g., "Làm chân", "Đan thân"
  final int quantity; // e.g., 4 (chân), 1 (thân)
  final double pricePerUnit;
  final double totalCost;
  final DateTime date;
  final int? materialId; // NEW
  final double? materialUsedAmount; // NEW

  OutsourcingLog({
    this.id,
    required this.workerName,
    required this.taskName,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalCost,
    required this.date,
    this.materialId,
    this.materialUsedAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'worker_name': workerName,
      'task_name': taskName,
      'quantity': quantity,
      'price_per_unit': pricePerUnit,
      'total_cost': totalCost,
      'date': date.toIso8601String(),
      'material_id': materialId,
      'material_used_amount': materialUsedAmount,
    };
  }

  factory OutsourcingLog.fromMap(Map<String, dynamic> map) {
    return OutsourcingLog(
      id: map['id'],
      workerName: map['worker_name'],
      taskName: map['task_name'],
      quantity: map['quantity'],
      pricePerUnit: map['price_per_unit'],
      totalCost: map['total_cost'],
      date: DateTime.parse(map['date']),
      materialId: map['material_id'],
      materialUsedAmount: map['material_used_amount'],
    );
  }
}
