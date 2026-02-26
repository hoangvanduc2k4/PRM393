class WorkerModel {
  final String id;
  final String name;
  final String? phone;
  final String? specialization;

  WorkerModel({
    required this.id,
    required this.name,
    this.phone,
    this.specialization,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'specialization': specialization,
    };
  }

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      specialization: map['specialization'],
    );
  }
}
