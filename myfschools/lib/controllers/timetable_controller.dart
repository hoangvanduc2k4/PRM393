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

  List<TimetableModel> getSlotsForDay(DateTime date) {
    return _allSlots.where((e) => 
      e.startTime.year == date.year && 
      e.startTime.month == date.month && 
      e.startTime.day == date.day
    ).toList();
  }
}
