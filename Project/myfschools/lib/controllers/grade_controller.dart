import 'package:flutter/material.dart';
import '../models/grade_model.dart';
import '../services/api_service.dart';

class GradeController extends ChangeNotifier {
  List<GradeModel> _allGrades = [];
  List<GradeModel> _filteredGrades = [];
  bool _isLoading = false;

  String _selectedYear = "2024-2025";
  String _selectedTerm = "Học kỳ 1";

  List<GradeModel> get filteredGrades => _filteredGrades;
  bool get isLoading => _isLoading;
  String get selectedTerm => _selectedTerm;
  String get selectedYear => _selectedYear;

  GradeController() {
    loadGrades();
  }

  Future<void> loadGrades() async {
    try {
      _isLoading = true;
      notifyListeners();

      final childId = await ApiService.getActiveChildId();
      if (childId == null) return;

      final data =
          await ApiService.get('/api/grades/by-child/$childId')
              as List<dynamic>;
      _allGrades = data
          .map((g) => GradeModel.fromApi(g as Map<String, dynamic>))
          .toList();

      applyFilter();
    } catch (e) {
      debugPrint("Lỗi tải điểm: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTerm(String term) {
    _selectedTerm = term;
    applyFilter();
  }

  void setYear(String year) {
    _selectedYear = year;
    applyFilter();
  }

  void applyFilter() {
    String dbTerm = _selectedTerm == "Học kỳ 1" ? "HK1" : "HK2";
    _filteredGrades = _allGrades
        .where((g) => g.term == dbTerm && g.year == _selectedYear)
        .toList();
    notifyListeners();
  }
}
