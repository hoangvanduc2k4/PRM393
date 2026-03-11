class GradeModel {
  final String id;
  final String subject;
  final String term;
  final String year;
  final double? quiz15Min;
  final double? oralTest;
  final double? test45Min;
  final double? finalExam;

  GradeModel({
    required this.id,
    required this.subject,
    required this.term,
    required this.year,
    this.quiz15Min,
    this.oralTest,
    this.test45Min,
    this.finalExam,
  });

  factory GradeModel.fromApi(Map<String, dynamic> data) {
    return GradeModel(
      id: data['id'] as String? ?? '',
      subject: data['subject'] as String? ?? 'Chưa cập nhật',
      term: data['term'] as String? ?? '',
      year: data['year'] as String? ?? '',
      quiz15Min: data['quiz15Min'] != null ? (data['quiz15Min'] as num).toDouble() : null,
      oralTest: data['oralTest'] != null ? (data['oralTest'] as num).toDouble() : null,
      test45Min: data['test45Min'] != null ? (data['test45Min'] as num).toDouble() : null,
      finalExam: data['finalExam'] != null ? (data['finalExam'] as num).toDouble() : null,
    );
  }
}
