class ScoreModel {
  final String subjectCode;
  final String subjectName;
  final double midTerm;
  final double finalTerm;
  final double process;
  final double total;
  final String status;

  ScoreModel({
    required this.subjectCode,
    required this.subjectName,
    required this.midTerm,
    required this.finalTerm,
    required this.process,
    required this.total,
    required this.status,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      subjectCode: json['subjectCode'],
      subjectName: json['subjectName'],
      midTerm: (json['midTerm'] as num).toDouble(),
      finalTerm: (json['finalTerm'] as num).toDouble(),
      process: (json['process'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'],
    );
  }

  static List<ScoreModel> getMockData() {
    return [
      ScoreModel(subjectCode: 'PRM392', subjectName: 'Mobile Programming', midTerm: 8.5, finalTerm: 9.0, process: 9.0, total: 8.9, status: 'Passed'),
      ScoreModel(subjectCode: 'SWP391', subjectName: 'Software Project', midTerm: 7.0, finalTerm: 8.0, process: 8.0, total: 7.8, status: 'Passed'),
      ScoreModel(subjectCode: 'IOT102', subjectName: 'Internet of Things', midTerm: 6.0, finalTerm: 5.0, process: 7.0, total: 6.0, status: 'Passed'),
    ];
  }
}
