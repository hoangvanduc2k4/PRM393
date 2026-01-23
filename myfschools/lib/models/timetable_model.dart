class TimetableModel {
  final String subjectCode;
  final String room;
  final DateTime startTime;
  final DateTime endTime;
  final String lecturer;

  TimetableModel({
    required this.subjectCode,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.lecturer,
  });

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
      subjectCode: json['subjectCode'],
      room: json['room'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      lecturer: json['lecturer'],
    );
  }

  static List<TimetableModel> getMockData() {
    final now = DateTime.now();
    return [
      TimetableModel(
        subjectCode: 'PRM392',
        room: '505',
        startTime: DateTime(now.year, now.month, now.day, 7, 30),
        endTime: DateTime(now.year, now.month, now.day, 9, 0),
        lecturer: 'DungPA',
      ),
      TimetableModel(
        subjectCode: 'PRM392',
        room: '505',
        startTime: DateTime(now.year, now.month, now.day + 2, 7, 30),
        endTime: DateTime(now.year, now.month, now.day + 2, 9, 0),
        lecturer: 'DungPA',
      ),
       TimetableModel(
        subjectCode: 'PRM392',
        room: 'Lab-302',
        startTime: DateTime(now.year, now.month, now.day + 4, 13, 30),
        endTime: DateTime(now.year, now.month, now.day + 4, 15, 0),
        lecturer: 'DungPA',
      ),
      TimetableModel(
        subjectCode: 'SWP391',
        room: '402',
        startTime: DateTime(now.year, now.month, now.day, 9, 30),
        endTime: DateTime(now.year, now.month, now.day, 11, 0),
        lecturer: 'LongND',
      ),
      TimetableModel(
        subjectCode: 'SWP391',
        room: '402',
        startTime: DateTime(now.year, now.month, now.day + 2, 9, 30),
        endTime: DateTime(now.year, now.month, now.day + 2, 11, 0),
        lecturer: 'LongND',
      ),
       TimetableModel(
        subjectCode: 'IOT102',
        room: 'Lab-IoT',
        startTime: DateTime(now.year, now.month, now.day + 1, 13, 30),
        endTime: DateTime(now.year, now.month, now.day + 1, 15, 0),
        lecturer: 'HieuTM',
      ),
    ];
  }
}
