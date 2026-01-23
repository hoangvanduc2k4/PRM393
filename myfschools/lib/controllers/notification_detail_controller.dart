import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationDetailController extends ChangeNotifier {
  final NotificationModel notification;

  NotificationDetailController(this.notification);
  
  void markAsRead() {
    // Mock API call to mark as read
    // In real app, this would call API
    notifyListeners();
  }
}
