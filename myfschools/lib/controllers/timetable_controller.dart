import 'package:flutter/material.dart';
import '../models/timetable_model.dart';

class TimetableController extends ChangeNotifier {
  bool isLoading = true;
  List<TimetableModel> _allSlots = [];

  TimetableController() {
    loadTimetable();
  }

  Future<void> loadTimetable() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    _allSlots = TimetableModel.getMockData();
    
    isLoading = false;
    notifyListeners();
  }

  List<String> getSubjects() {
    // Get unique subject codes
    return _allSlots.map((e) => e.subjectCode).toSet().toList();
  }

  List<TimetableModel> getSlotsForSubject(String subjectCode) {
    return _allSlots.where((e) => e.subjectCode == subjectCode).toList();
  }
}
