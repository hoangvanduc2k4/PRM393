import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/notification_card.dart';
import '../../controllers/notification_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController _notificationController = NotificationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.notifications, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: TColors.sunshade, // Light Orange
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: AnimatedBuilder(
          animation: _notificationController,
          builder: (context, _) {
            if (_notificationController.isLoading) {
              return const Center(child: CircularProgressIndicator(color: TColors.sunshade));
            }

            if (_notificationController.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.notification_bing, size: 60, color: TColors.grey),
                    const SizedBox(height: TSizes.sm),
                    Text("Không có thông báo nào", style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: _notificationController.notifications.length,
              itemBuilder: (context, index) {
                final note = _notificationController.notifications[index];
                return GestureDetector(
                  onTap: () {
                    if (!note.isRead) {
                       _notificationController.markAsRead(note.id);
                    }
                  },
                  child: NotificationCard(
                    title: note.title,
                    content: note.message,
                    time: note.time,
                    date: note.date,
                    isImportant: !note.isRead, // "Chưa đọc" tì viền cam/đậm cho nổi bêt
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }
}
