import 'package:flutter/material.dart';
import '../models/attendance_timeline_model.dart';

class AttendanceController extends ChangeNotifier {
  bool isLoading = true;
  List<AttendanceTimelineModel> timelineList = [];

  AttendanceController() {
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    timelineList = AttendanceTimelineModel.getMockData();
    
    isLoading = false;
    notifyListeners();
  }
}
