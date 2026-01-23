class AttendanceModel {
  final String course;
  final int absent;
  final int totalSlots;
  final double absentPercentage;

  AttendanceModel({
    required this.course,
    required this.absent,
    required this.totalSlots,
    required this.absentPercentage,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      course: json['course'],
      absent: json['absent'],
      totalSlots: json['totalSlots'],
      absentPercentage: (json['absentPercentage'] as num).toDouble(),
    );
  }

  static List<AttendanceModel> getMockData() {
    return [
      AttendanceModel(course: 'PRM392', absent: 1, totalSlots: 30, absentPercentage: 3.3),
      AttendanceModel(course: 'SWP391', absent: 0, totalSlots: 30, absentPercentage: 0.0),
      AttendanceModel(course: 'IOT102', absent: 3, totalSlots: 30, absentPercentage: 10.0),
    ];
  }
}
