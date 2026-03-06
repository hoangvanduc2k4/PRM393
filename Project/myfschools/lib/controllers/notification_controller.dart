import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/api_service.dart';

class NotificationController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  NotificationController() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = await ApiService.getUserId();
      if (userId == null) return;

      final data =
          await ApiService.get('/api/notifications/by-user/$userId')
              as List<dynamic>;
      _notifications = data
          .map((n) => NotificationModel.fromApi(n as Map<String, dynamic>))
          .toList();

      // Sắp xếp: mới nhất lên đầu
      _notifications.sort((a, b) => b.createdAtUTC.compareTo(a.createdAtUTC));
    } catch (e) {
      debugPrint("Lỗi tải thông báo: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1 || _notifications[index].isRead) return;

    // Cập nhật UI ngay lập tức
    _notifications[index].isRead = true;
    notifyListeners();

    try {
      await ApiService.patch('/api/notifications/$notificationId/read');
    } catch (e) {
      // Rollback nếu lỗi
      _notifications[index].isRead = false;
      notifyListeners();
      debugPrint("Lỗi đánh dấu đã đọc: $e");
    }
  }
}
