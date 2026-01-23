class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      isRead: json['isRead'] ?? false,
    );
  }

  static List<NotificationModel> getMockData() {
    return [
      NotificationModel(
        id: '1',
        title: 'Re-exam Schedule for PRM392',
        message: 'Students please note the re-exam schedule for PRM392 on Jan 25, 2026 at room 505.',
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '2',
        title: 'Tuition Fee Payment Notice',
        message: 'Deadline for Spring 2026 tuition fee is Feb 10, 2026.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '3',
        title: 'Welcome Freshmen Event',
        message: 'K19 students join orientation this Saturday morning.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }
}
