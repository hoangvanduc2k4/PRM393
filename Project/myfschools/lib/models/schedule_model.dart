class ScheduleModel {
  final String id;
  final String className;
  final String dayOfWeek;
  final int slot;
  final String subject;
  final String teacher;
  final String room;
  final String term;

  ScheduleModel({
    required this.id,
    required this.className,
    required this.dayOfWeek,
    required this.slot,
    required this.subject,
    required this.teacher,
    required this.room,
    required this.term,
  });

  factory ScheduleModel.fromApi(Map<String, dynamic> data) {
    return ScheduleModel(
      id: data['id'] ?? '',
      className: data['className'] ?? '',
      dayOfWeek: data['dayOfWeek'] ?? '',
      slot: data['slot'] ?? 1,
      subject: data['subject'] ?? '',
      teacher: data['teacher'] ?? '',
      room: data['room'] ?? '',
      term: data['term'] ?? '',
    );
  }
}
