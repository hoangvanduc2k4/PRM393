import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../services/api_service.dart';

class TeacherScheduleController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<ScheduleModel> _schedules = [];
  List<ScheduleModel> get schedules => _schedules;

  final List<String> namHocList = ["2024-2025", "2025-2026"];
  late String namChon;

  final List<String> tuanList = ["10/03 - 16/03", "17/03 - 23/03"];
  late String tuanChon;

  TeacherScheduleController() {
    namChon = namHocList[0];
    tuanChon = tuanList[0];
  }

  void updateNamChon(String value) {
    namChon = value;
    notifyListeners();
  }

  void updateTuanChon(String value) {
    tuanChon = value;
    notifyListeners();
  }

  // matrix[col][row] - 7 cols, 5 rows
  List<List<String>> get monHocMatrix {
    List<List<String>> matrix = List.generate(7, (_) => List.filled(5, "-"));

    for (var schedule in _schedules) {
      int colIndex = _getDayIndex(schedule.dayOfWeek);
      int rowIndex = schedule.slot - 1; 

      if (colIndex >= 0 && colIndex < 7 && rowIndex >= 0 && rowIndex < 5) {
        matrix[colIndex][rowIndex] = "${schedule.subject}\n(${schedule.className})\n${schedule.room}";
      }
    }
    return matrix;
  }

  int _getDayIndex(String day) {
    final lower = day.toLowerCase();
    if (lower.contains("2")) return 0;
    if (lower.contains("3")) return 1;
    if (lower.contains("4")) return 2;
    if (lower.contains("5")) return 3;
    if (lower.contains("6")) return 4;
    if (lower.contains("7")) return 5;
    if (lower.contains("cn") || lower.contains("chủ nhật")) return 6;
    return -1;
  }

  Future<void> fetchTeacherSchedule(String teacherEmail) async {
    if (teacherEmail.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/api/schedules/teacher/$teacherEmail');
      if (response != null && response is List) {
        _schedules = response.map((json) => ScheduleModel.fromApi(json)).toList();
      }
    } catch (e) {
      _error = "Lỗi khi tải lịch dạy: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
