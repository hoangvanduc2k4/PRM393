import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../models/notification_model.dart';

class HomeController extends ChangeNotifier {
  bool isLoading = true;
  StudentModel? student;
  List<NotificationModel> recentNotifications = [];

  HomeController() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    student = StudentModel.getMockData();
    recentNotifications = NotificationModel.getMockData().take(2).toList();
    
    isLoading = false;
    notifyListeners();
  }
}
