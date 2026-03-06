import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventModel {
  final String id;
  final String eventName;
  final String dateString;
  final String monthString;
  final String time;
  final String location;
  final Color color;
  final DateTime createdAt;
  final DateTime eventDate;

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

  factory EventModel.fromApi(Map<String, dynamic> data) {
    DateTime dt = DateTime.now();
    try {
      final rawDate = data['eventDate'] ?? data['date'] ?? '';
      if (rawDate.isNotEmpty) dt = DateTime.parse(rawDate);
    } catch (_) {}

    Color eventColor = Colors.blue;
    final colorStr = (data['color'] ?? 'blue').toString().toLowerCase();
    if (colorStr == 'red') eventColor = Colors.red;
    if (colorStr == 'green') eventColor = Colors.green;
    if (colorStr == 'orange') eventColor = Colors.orange;
    if (colorStr == 'purple') eventColor = Colors.purple;

    DateTime createdAt = DateTime.now();
    try {
      final rawCreated = data['createdAt'] ?? '';
      if (rawCreated.isNotEmpty) createdAt = DateTime.parse(rawCreated);
    } catch (_) {}

    return EventModel(
      id: data['id'] ?? '',
      eventName: data['eventName'] ?? 'Sự kiện chưa đặt tên',
      dateString: DateFormat('dd').format(dt),
      monthString: 'TH${DateFormat('MM').format(dt)}',
      time: data['time'] ?? '08:00 - 11:00',
      location: data['location'] ?? 'Trường học',
      color: eventColor,
      createdAt: createdAt,
      eventDate: dt,
    );
  }
}
