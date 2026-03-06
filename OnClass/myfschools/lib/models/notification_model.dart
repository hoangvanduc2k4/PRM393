import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  bool isRead;
  final String date; // dd/MM/yyyy
  final String time; // HH:mm
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

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    
    // Xử lý ngày giờ cơ bản, an toàn
    String rawDate = data['createdAt'] ?? '';
    DateTime dt = DateTime.now();
    try {
      if (rawDate.isNotEmpty) {
        dt = DateTime.parse(rawDate);
      } else if (data['createdAt'] is Timestamp) {
        dt = (data['createdAt'] as Timestamp).toDate();
      }
    } catch (e) {
      // Mặc định là DateTime.now() nếu lỗi
    }

    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? 'Không có tiêu đề',
      message: data['message'] ?? 'Không có nội dung',
      type: data['type'] ?? 'Hệ thống',
      isRead: data['isRead'] ?? false,
      date: DateFormat('dd/MM/yyyy').format(dt),
      time: DateFormat('HH:mm').format(dt),
      createdAtUTC: dt, // Lưu lại gốc để sort
    );
  }
}
