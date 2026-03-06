import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventModel {
  final String id;
  final String eventName;
  final String dateString; // Ví dụ: "15"
  final String monthString; // Ví dụ: "TH08"
  final String time;
  final String location;
  final Color color;
  final DateTime createdAt;
  final DateTime eventDate; // Thêm trường này để dễ sort

  EventModel({
    required this.id,
    required this.eventName,
    required this.dateString,
    required this.monthString,
    required this.time,
    required this.location,
    required this.color,
    required this.createdAt,
    required this.eventDate,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    // Xử lý ngày tháng từ chuỗi ISO8601 sang text hiển thị "Ngày" và "Tháng"
    String rawDate = data['date'] ?? '';
    DateTime dt = DateTime.now();
    try {
      if (rawDate.isNotEmpty) {
        dt = DateTime.parse(rawDate);
      } else if (data['date'] is Timestamp) {
        dt = (data['date'] as Timestamp).toDate();
      }
    } catch (e) {
      // Mặc định
    }

    // Chuyển màu từ String -> Color (VD: "blue", "red", "green")
    Color eventColor = Colors.blue;
    String colorStr = (data['color'] ?? 'blue').toString().toLowerCase();
    if (colorStr == 'red') eventColor = Colors.red;
    if (colorStr == 'green') eventColor = Colors.green;
    if (colorStr == 'orange') eventColor = Colors.orange;
    if (colorStr == 'purple') eventColor = Colors.purple;

    return EventModel(
      id: doc.id,
      eventName: data['eventName'] ?? 'Sự kiện chưa đặt tên',
      dateString: DateFormat('dd').format(dt),       // Chỉ lấy Ngày (VD: 15)
      monthString: "TH${DateFormat('MM').format(dt)}", // Chỉ lấy Tháng (VD: TH08)
      time: data['time'] ?? '08:00 - 11:00',
      location: data['location'] ?? 'Trường học',
      color: eventColor,
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      eventDate: dt, // Trả luôn cái mốc thời gian thực của sự kiện
    );
  }
}
