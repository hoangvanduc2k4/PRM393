import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  bool isRead;
  final String date;
  final String time;
  final DateTime createdAtUTC;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.date,
    required this.time,
    required this.createdAtUTC,
  });

  factory NotificationModel.fromApi(Map<String, dynamic> data) {
    DateTime dt = DateTime.now();
    try {
      final raw = data['createdAt'] ?? '';
      if (raw.isNotEmpty) dt = DateTime.parse(raw);
    } catch (_) {}

    return NotificationModel(
      id: data['id'] ?? '',
      title: data['title'] ?? 'Không có tiêu đề',
      message: data['message'] ?? 'Không có nội dung',
      type: data['type'] ?? 'Hệ thống',
      isRead: data['isRead'] ?? false,
      date: DateFormat('dd/MM/yyyy').format(dt),
      time: DateFormat('HH:mm').format(dt),
      createdAtUTC: dt,
    );
  }
}
