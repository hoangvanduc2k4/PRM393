import 'package:cloud_firestore/cloud_firestore.dart';

class GradeModel {
  final String id;
  final String subject;
  final String term;
  final double average;
  final String status;

  GradeModel({
    required this.id,
    required this.subject,
    required this.term,
    required this.average,
    required this.status,
  });

  factory GradeModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return GradeModel(
      id: doc.id,
      subject: data['subject'] ?? 'Môn học ẩn',
      term: data['term'] ?? 'Học kỳ 1 - 2024-2025',
      average: (data['average'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'Not Yet',
    );
  }
}
