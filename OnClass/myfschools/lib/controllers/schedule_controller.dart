import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/schedule_model.dart';
import 'package:intl/intl.dart';

class ScheduleController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ScheduleModel> _allSchedules = [];
  List<ScheduleModel> _dailySchedules = [];
  bool _isLoading = false;
  
  String _currentClassName = "3A1"; // Mặc định để phòng lỗi

  List<ScheduleModel> get dailySchedules => _dailySchedules;
  bool get isLoading => _isLoading;

  ScheduleController() {
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Lên Firebase lấy thông tin LỚP của học sinh hiện tại
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
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
              String currentChildId;

              if (activeChildId != null && keys.contains(activeChildId)) {
                 currentChildId = activeChildId;
              } else {
                 currentChildId = keys.first; 
              }

              var childData = childrenMap[currentChildId] as Map<String, dynamic>;
              _currentClassName = childData['className'] ?? "3A1";
            }
          }
        }
      }

      // 2. Tải toàn bộ lịch học CỦA LỚP ĐÓ từ Firebase về
      QuerySnapshot query = await _firestore
          .collection('schedules')
          .where('className', isEqualTo: _currentClassName)
          .get();

      // Chuyển Map thành Model
      _allSchedules = query.docs.map((doc) => ScheduleModel.fromFirestore(doc)).toList();

      // Mặc định ban đầu gọi filter ảo (sẽ bị ghi đè bởi màn hình ngay lập tức)
      filterByDate(DateTime.now());

    } catch (e) {
      print("Lỗi tải lịch học: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm chuyển đổi từ DateTime (hiện tại) sang "Thứ 2", "Thứ 3"... để khớp với Database
  void filterByDate(DateTime date) {
    if (_allSchedules.isEmpty) return;

    int weekdayNumber = date.weekday; 
    String dayString = "Thứ 2"; // Mặc định
    
    // logic chuyển thứ
    if (weekdayNumber == 1) dayString = "Thứ 2";
    if (weekdayNumber == 2) dayString = "Thứ 3";
    if (weekdayNumber == 3) dayString = "Thứ 4";
    if (weekdayNumber == 4) dayString = "Thứ 5";
    if (weekdayNumber == 5) dayString = "Thứ 6";
    if (weekdayNumber == 6) dayString = "Thứ 7";
    if (weekdayNumber == 7) dayString = "Chủ nhật";

    // Phân loại list lịch học theo cái thứ đó
    _dailySchedules = _allSchedules.where((sched) => sched.dayOfWeek == dayString).toList();
    
    // Sort theo ca (slot 1 -> 5)
    _dailySchedules.sort((a, b) => a.slot.compareTo(b.slot));

    notifyListeners();
  }
}
