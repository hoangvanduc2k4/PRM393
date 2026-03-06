import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FormModel {
  final String id;
  final String title;
  final String type;
  final String date;
  final String reason;
  final String status;
  final DateTime createdAt;

  FormModel({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  factory FormModel.fromApi(Map<String, dynamic> data) {
    return FormModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      date: data['date'] ?? '',
      reason: data['reason'] ?? '',
      status: data['status'] ?? 'Chờ duyệt',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class FormController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<FormModel> _forms = [];
  List<FormModel> get forms => _forms;

  FormController() {
    fetchForms();
  }

  Future<void> fetchForms() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = await ApiService.getUserId();
      final childId = await ApiService.getActiveChildId();

      if (userId == null) return;

      // Lấy forms theo user và filter theo childId nếu có
      final path = childId != null
          ? '/api/forms/by-child/$childId'
          : '/api/forms/by-user/$userId';

      final data = await ApiService.get(path) as List<dynamic>;
      _forms = data
          .map((f) => FormModel.fromApi(f as Map<String, dynamic>))
          .toList();

      // Sắp xếp: mới nhất lên đầu
      _forms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint("Lỗi tải đơn: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> submitForm({
    required String type,
    required String reason,
    required String date,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = await ApiService.getUserId();
      final childId = await ApiService.getActiveChildId();

      if (userId == null || childId == null) {
        throw Exception("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
      }

      String title = type.startsWith("Xin ")
          ? "Đơn ${type.toLowerCase()}"
          : "Đơn từ";

      await ApiService.post('/api/forms', {
        'userId': userId,
        'childId': childId,
        'title': title,
        'type': type,
        'reason': reason,
        'date': date,
        'status': 'Chờ duyệt',
      });

      await fetchForms();
      return null; // Thành công
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
