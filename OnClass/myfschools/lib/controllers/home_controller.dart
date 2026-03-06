import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/child_model.dart';

class HomeController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _parentName = "";
  String get parentName => _parentName;

  String _parentPhone = "";
  String get parentPhone => _parentPhone;

  List<ChildModel> _children = [];
  List<ChildModel> get children => _children;

  ChildModel? _selectedChild;
  ChildModel? get selectedChild => _selectedChild;

  // Lấy dữ liệu tiện lợi (backward compatibility)
  String get childName => _selectedChild?.childName ?? "Chưa cập nhật";
  String get childId => _selectedChild?.childId ?? "N/A";
  String get className => _selectedChild?.className ?? "N/A";
  String get avatarUrl => _selectedChild?.avatarUrl ?? "";

  HomeController() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          
          _parentName = data['name'] ?? "Phụ huynh";
          _parentPhone = data['phoneNumber'] ?? data['phone'] ?? "";
          String? activeChildId = data['activeChildId'];

          var childrenData = data['children'] ?? data['chidren'];
          if (childrenData != null) {
             Map<String, dynamic> childrenMap = childrenData as Map<String, dynamic>;
             _children.clear();
             
             // Sort values and add to List
             var keys = childrenMap.keys.toList()..sort();
             for (String key in keys) {
                var childData = childrenMap[key] as Map<String, dynamic>;
                _children.add(ChildModel.fromMap(childData));
             }

             if (_children.isNotEmpty) {
                // Nếu activeChildId có trong danh sách thì chọn, không thì chọn đứa đầu mảng
                if (activeChildId != null && _children.any((c) => c.childId == activeChildId)) {
                  _selectedChild = _children.firstWhere((c) => c.childId == activeChildId);
                } else {
                  _selectedChild = _children.first;
                  // Nên update lại DB luôn nếu DB chưa có activeChildId
                  _updateActiveChildToFirebase(_selectedChild!.childId);
                }
             }
          }
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm chuyển đổi Học Sinh
  Future<void> switchChild(String childId) async {
    if (_selectedChild?.childId == childId) return; // Không đổi nếu trùng

    try {
      var newChild = _children.firstWhere((c) => c.childId == childId);
      
      _selectedChild = newChild;
      notifyListeners(); // UI đổi ngay lập tức cho mượt

      // Update lên Firebase
      await _updateActiveChildToFirebase(childId);
      
    } catch (e) {
      print("Error switching child: $e");
    }
  }

  Future<void> _updateActiveChildToFirebase(String childId) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).set({
        'activeChildId': childId
      }, SetOptions(merge: true));
    }
  }
}

