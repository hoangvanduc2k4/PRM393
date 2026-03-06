import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../services/api_service.dart';

class ScheduleController extends ChangeNotifier {
  List<ScheduleModel> _allSchedules = [];
  List<ScheduleModel> _dailySchedules = [];
  bool _isLoading = false;

  List<ScheduleModel> get dailySchedules => _dailySchedules;
  bool get isLoading => _isLoading;

  ScheduleController() {
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    try {
      _isLoading = true;
      notifyListeners();

      final childId = await ApiService.getActiveChildId();
      if (childId == null) return;

      // Lấy thông tin className của child hiện tại
      final childData =
          await ApiService.get('/api/children/$childId')
              as Map<String, dynamic>;
      final className = childData['className'] ?? '3A1';

      // Tải toàn bộ lịch học của lớp đó
      final data =
          await ApiService.get('/api/schedules/by-class/$className')
              as List<dynamic>;
      _allSchedules = data
          .map((s) => ScheduleModel.fromApi(s as Map<String, dynamic>))
          .toList();

      // Filter mặc định theo ngày hiện tại
      filterByDate(DateTime.now());
    } catch (e) {
      debugPrint("Lỗi tải lịch học: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByDate(DateTime date) {
    if (_allSchedules.isEmpty) return;

    const dayMap = {
      1: 'Thứ 2',
      2: 'Thứ 3',
      3: 'Thứ 4',
      4: 'Thứ 5',
      5: 'Thứ 6',
      6: 'Thứ 7',
      7: 'Chủ nhật',
    };
    final dayString = dayMap[date.weekday] ?? 'Thứ 2';

    _dailySchedules = _allSchedules
        .where((s) => s.dayOfWeek == dayString)
        .toList();
    _dailySchedules.sort((a, b) => a.slot.compareTo(b.slot));
    notifyListeners();
  }
}
