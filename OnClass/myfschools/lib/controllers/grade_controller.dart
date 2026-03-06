import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/grade_model.dart';

class GradeController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<GradeModel> _allGrades = [];
  List<GradeModel> _filteredGrades = [];
  bool _isLoading = false;

  String _currentChildId = "SOO1"; 
  String _selectedYear = "2025-2026"; 
  String _selectedTerm = "Học kỳ 1"; // Tách riêng Học kỳ và Chọn năm

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

      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Lấy con đầu tiên của user
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          // Lấy activeChildId
          String? activeChildId = data['activeChildId'];

          var childrenData = data['children'] ?? data['chidren'];
          
          if (childrenData != null) {
            Map<String, dynamic> childrenMap = childrenData as Map<String, dynamic>;
            if (childrenMap.isNotEmpty) {
              var keys = childrenMap.keys.toList()..sort();

              if (activeChildId != null && keys.contains(activeChildId)) {
                 _currentChildId = activeChildId;
              } else {
                 _currentChildId = keys.first; 
              }
            }
          }
        }
      }

      // Lấy danh sách điểm của đúng đứa con đó
      QuerySnapshot query = await _firestore
          .collection('grades')
          .where('childId', isEqualTo: _currentChildId)
          .get();

      _allGrades = query.docs.map((doc) => GradeModel.fromFirestore(doc)).toList();
      
      applyFilter();

    } catch (e) {
      print("Lỗi tải điểm: $e");
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
    // DB đang lưu dạng "Học kỳ 2 - 2026". "2026" là lấy 4 số cuối của "2025-2026"
    String targetYearSuffix = _selectedYear.split('-').last;
    String filterKeyword = "$_selectedTerm - $targetYearSuffix";

    _filteredGrades = _allGrades.where((g) => g.term.contains(filterKeyword)).toList();
    notifyListeners();
  }
}
