import 'package:flutter/material.dart';
import '../models/club_model.dart';
import '../services/api_service.dart';

class ClubController extends ChangeNotifier {
  List<ClubModel> _allClubs = [];
  List<ClubModel> _joinedClubs = [];
  List<ClubModel> _searchResults = [];

  bool _isLoading = false;
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

      final activeChildId = await ApiService.getActiveChildId();

      // 1. Tất cả CLB
      final allData = await ApiService.get('/api/clubs') as List<dynamic>;
      _allClubs = allData.map((c) => ClubModel.fromApi(c)).toList();

      // 2. CLB của học sinh hiện tại
      if (activeChildId != null) {
        final joinedData =
            await ApiService.get('/api/clubs/by-child/$activeChildId')
                as List<dynamic>;
        final joinedIds = joinedData.map((c) => c['id'] as String).toSet();
        // Đánh dấu isJoined
        _allClubs = _allClubs
            .map((c) => c.copyWith(isJoined: joinedIds.contains(c.id)))
            .toList();
        _joinedClubs = _allClubs.where((c) => c.isJoined).toList();
      }

      _applyFilters();
    } catch (e) {
      debugPrint("Lỗi tải CLB: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> joinClub(String clubId) async {
    final childId = await ApiService.getActiveChildId();
    if (childId == null) return;
    try {
      await ApiService.post('/api/clubs/$clubId/join/$childId', {});
      await loadClubs();
    } catch (e) {
      debugPrint("Lỗi tham gia CLB: $e");
    }
  }

  Future<void> leaveClub(String clubId) async {
    final childId = await ApiService.getActiveChildId();
    if (childId == null) return;
    try {
      await ApiService.delete('/api/clubs/$clubId/leave/$childId');
      await loadClubs();
    } catch (e) {
      debugPrint("Lỗi rời CLB: $e");
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _searchResults = _allClubs.where((club) {
      bool matchQuery = club.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      bool matchCat =
          _selectedCategory == "Tất cả" || club.category == _selectedCategory;
      return matchQuery && matchCat;
    }).toList();
    notifyListeners();
  }
}
