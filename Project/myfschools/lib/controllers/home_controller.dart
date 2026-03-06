import 'package:flutter/material.dart';
import '../models/child_model.dart';
import '../services/api_service.dart';

class HomeController extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _parentPhone = "";
  String get parentPhone => _parentPhone;

  List<ChildModel> _children = [];
  List<ChildModel> get children => _children;

  ChildModel? _selectedChild;
  ChildModel? get selectedChild => _selectedChild;

  String get childName => _selectedChild?.childName ?? "Chưa cập nhật";
  String get childId => _selectedChild?.childId ?? "";
  String get className => _selectedChild?.className ?? "N/A";
  String get avatarUrl => _selectedChild?.avatarUrl ?? "";

  HomeController() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = await ApiService.getUserId();
      if (userId == null) return;

      // Lấy user kèm children từ API
      final data = await ApiService.get('/api/users/$userId/with-children');
      _parentPhone = data['phone'] ?? '';

      final childrenRaw = data['children'] as List<dynamic>? ?? [];
      _children = childrenRaw
          .map(
            (c) => ChildModel.fromMap({
              'childId': c['id'],
              'childName': c['fullName'],
              'className': c['className'],
              'avatarUrl': c['avatarUrl'] ?? '',
            }),
          )
          .toList();

      if (_children.isNotEmpty) {
        final activeChildId = await ApiService.getActiveChildId();
        if (activeChildId != null &&
            _children.any((c) => c.childId == activeChildId)) {
          _selectedChild = _children.firstWhere(
            (c) => c.childId == activeChildId,
          );
        } else {
          _selectedChild = _children.first;
          await ApiService.setActiveChildId(_selectedChild!.childId);
          // Cập nhật lên server
          await ApiService.patch('/api/users/$userId/active-child', {
            'activeChildId': _selectedChild!.childId,
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> switchChild(String newChildId) async {
    if (_selectedChild?.childId == newChildId) return;

    try {
      final newChild = _children.firstWhere((c) => c.childId == newChildId);
      _selectedChild = newChild;
      notifyListeners();

      // Cập nhật local + server
      await ApiService.setActiveChildId(newChildId);
      final userId = await ApiService.getUserId();
      if (userId != null) {
        await ApiService.patch('/api/users/$userId/active-child', {
          'activeChildId': newChildId,
        });
      }
    } catch (e) {
      debugPrint("Error switching child: $e");
    }
  }

  Future<void> refresh() => _loadUserData();
}
