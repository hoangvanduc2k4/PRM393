import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/club_model.dart';

class ClubController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ClubModel> _allClubs = [];
  List<ClubModel> _joinedClubs = [];
  List<ClubModel> _searchResults = [];
  
  bool _isLoading = false;
  String _currentChildId = "SOO1"; // Mặc định

  String _searchQuery = "";
  String _selectedCategory = "Tất cả";

  List<ClubModel> get allClubs => _allClubs;
  List<ClubModel> get joinedClubs => _joinedClubs;
  List<ClubModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  ClubController() {
    loadClubs();
  }

  Future<void> loadClubs() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Lấy thông tin childId hiện tại từ user profile
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

              if (activeChildId != null && keys.contains(activeChildId)) {
                 _currentChildId = activeChildId;
              } else {
                 _currentChildId = keys.first; 
              }
            }
          }
        }
      }

      // 2. Fetch danh sách toàn bộ CLB từ Firebase
      QuerySnapshot query = await _firestore.collection('clubs').get();
      
      _allClubs = query.docs.map((doc) => ClubModel.fromFirestore(doc, _currentChildId)).toList();

      // 3. Phân loại
      _joinedClubs = _allClubs.where((club) => club.isJoined).toList();
      _applyFilters();

    } catch (e) {
      print("Lỗi tải danh sách CLB: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nhật từ khóa tìm kiếm
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Cập nhật bộ lọc thể loại
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Áp dụng bộ lọc (những cái chưa tham gia / đã tham gia đều hiện trong "Toàn bộ")
  void _applyFilters() {
    _searchResults = _allClubs.where((club) {
      bool matchQuery = club.name.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchCat = _selectedCategory == "Tất cả" || club.category == _selectedCategory;
      return matchQuery && matchCat;
    }).toList();
    notifyListeners();
  }

}

