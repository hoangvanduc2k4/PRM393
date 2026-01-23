import 'package:flutter/material.dart';
import '../../controllers/notifications_controller.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/helpers/date_formatting.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';
import 'notification_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  final NotificationsController _controller = NotificationsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notifications)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const LoadingIndicator();
          }
          if (_controller.notifications.isEmpty) {
            return const EmptyState(message: 'No notifications');
          }
          return ListView.separated(
            itemCount: _controller.notifications.length,
            separatorBuilder: (ctx, index) => const Divider(height: 1),
            itemBuilder: (ctx, index) {
              final item = _controller.notifications[index];
              return ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: item.isRead ? Colors.grey : Colors.blue,
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(DateFormatting.formatDayMonthYear(item.date)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationDetailScreen(item: item),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
