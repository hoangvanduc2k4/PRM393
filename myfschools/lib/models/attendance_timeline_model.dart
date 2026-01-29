class AttendanceTimelineModel {
  final String courseName;
  final String courseCode;
  final String startTime;
  final String endTime;
  final String room;
  final String lecturer;
  final String status; // "Có mặt", "Vắng mặt", "Chưa điểm danh"

  AttendanceTimelineModel({
    required this.courseName,
    required this.courseCode,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.lecturer,
    required this.status,
  });

  static List<AttendanceTimelineModel> getMockData() {
    return [
      AttendanceTimelineModel(
        courseName: 'Ngoại Ngữ 1 (Tiếng Anh)',
        courseCode: 'ENT1126',
        startTime: '07:45',
        endTime: '08:30',
        room: 'P402', // Using icon instead of text "Room" in design, assuming implicit
        lecturer: 'Phạm Quỳnh Giang',
        status: 'Có mặt',
      ),
      AttendanceTimelineModel(
        courseName: 'Ngoại Ngữ 1 (Tiếng Anh)',
        courseCode: 'ENT1126',
        startTime: '08:35',
        endTime: '09:20',
        room: 'P402',
        lecturer: 'Phạm Quỳnh Giang',
        status: 'Có mặt',
      ),
      AttendanceTimelineModel(
        courseName: 'Toán',
        courseCode: 'MAT101',
        startTime: '09:25',
        endTime: '10:10',
        room: 'P501',
        lecturer: 'Hà Thị Thu Lý',
        status: 'Có mặt',
      ),
    ];
  }
}
