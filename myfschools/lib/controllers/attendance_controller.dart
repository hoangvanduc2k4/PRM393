import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendanceController extends ChangeNotifier {
  bool isLoading = true;
  List<AttendanceModel> attendanceList = [];

  AttendanceController() {
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    attendanceList = AttendanceModel.getMockData();
    
    isLoading = false;
    notifyListeners();
  }
}
