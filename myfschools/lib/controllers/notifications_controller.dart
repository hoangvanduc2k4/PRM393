import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationsController extends ChangeNotifier {
  bool isLoading = true;
  List<NotificationModel> notifications = [];

  NotificationsController() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    notifications = NotificationModel.getMockData();
    
    isLoading = false;
    notifyListeners();
  }
}
