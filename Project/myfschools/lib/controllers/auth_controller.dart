import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _userId;
  String? get userId => _userId;

  // Login bằng số điện thoại + mật khẩu
  Future<String?> login(String phone, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await ApiService.post('/api/auth/login', {
        'phone': phone.trim(),
        'password': password,
      });

      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      await ApiService.saveSession(
        token: token,
        userId: user['id'] as String,
        phone: user['phone'] as String? ?? phone,
        activeChildId: user['activeChildId'] as String?,
      );

      _userId = user['id'] as String;
      _isLoading = false;
      notifyListeners();
      return null; // null = thành công
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  // Đổi mật khẩu qua API
  Future<String?> resetPassword(String phone, String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();

      return 'Chức năng đổi mật khẩu chưa hỗ trợ từ client. Liên hệ admin.';
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> logout() async {
    await ApiService.clearSession();
    _userId = null;
    notifyListeners();
  }

  // Kiểm tra có token chưa (đã login chưa)
  Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null;
  }
}
