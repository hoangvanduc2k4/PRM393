import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../controllers/notification_detail_controller.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/helpers/date_formatting.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel item;
  late final NotificationDetailController _controller;

  NotificationDetailScreen({Key? key, required this.item}) : super(key: key) {
    _controller = NotificationDetailController(item);
    _controller.markAsRead(); // Mark read when opening
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Detail')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormatting.formatDayMonthYear(item.date),
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),
            Text(
              item.message,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
