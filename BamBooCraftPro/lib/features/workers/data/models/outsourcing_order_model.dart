class OutsourcingOrderModel {
  final String id;
  final String workerId;
  final DateTime assignedDate;
  final String status;
  final double totalPayment;

  OutsourcingOrderModel({
    required this.id,
    required this.workerId,
    required this.assignedDate,
    required this.status,
    required this.totalPayment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'worker_id': workerId,
      'assigned_date': assignedDate.toIso8601String(),
      'status': status,
      'total_payment': totalPayment,
    };
  }

  factory OutsourcingOrderModel.fromMap(Map<String, dynamic> map) {
    return OutsourcingOrderModel(
      id: map['id'],
      workerId: map['worker_id'],
      assignedDate: DateTime.parse(map['assigned_date']),
      status: map['status'],
      totalPayment: (map['total_payment'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OutsourcingItemModel {
  final String id;
  final String orderId;
  final String partName;
  final int quantityPairs;
  final double pricePerPair;

  OutsourcingItemModel({
    required this.id,
    required this.orderId,
    required this.partName,
    required this.quantityPairs,
    required this.pricePerPair,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'part_name': partName,
      'quantity_pairs': quantityPairs,
      'price_per_pair': pricePerPair,
    };
  }

  factory OutsourcingItemModel.fromMap(Map<String, dynamic> map) {
    return OutsourcingItemModel(
      id: map['id'],
      orderId: map['order_id'],
      partName: map['part_name'],
      quantityPairs: map['quantity_pairs'],
      pricePerPair: map['price_per_pair'],
    );
  }
}
