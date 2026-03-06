import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // API đã publish tại localhost:5000
  // Lưu ý: nếu chạy trên Android Emulator thì dùng 'http://10.0.2.2:5000'
  static const String baseUrl = 'https://localhost:7207';

  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userPhoneKey = 'user_phone';
  static const String _activeChildIdKey = 'active_child_id';

  // ─── Token Management ───────────────────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveSession({
    required String token,
    required String userId,
    required String phone,
    String? activeChildId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userPhoneKey, phone);
    if (activeChildId != null) {
      await prefs.setString(_activeChildIdKey, activeChildId);
    }
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_activeChildIdKey);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<String?> getActiveChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeChildIdKey);
  }

  static Future<void> setActiveChildId(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeChildIdKey, childId);
  }

  // ─── HTTP Headers ───────────────────────────────────────────────
  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── Generic request helpers ────────────────────────────────────
  static Future<dynamic> get(String path) async {
    final res = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
    _checkStatus(res);
    return jsonDecode(res.body);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    _checkStatus(res);
    return jsonDecode(res.body);
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    _checkStatus(res);
    return jsonDecode(res.body);
  }

  static Future<dynamic> patch(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final res = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    _checkStatus(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  static Future<void> delete(String path) async {
    final res = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
    _checkStatus(res);
  }

  // ─── Authentication ─────────────────────────────────────────────
  static Future<void> login(String phone, String password) async {
    final res = await post('/api/auth/login', {
      'phone': phone,
      'password': password,
    });

    await saveSession(
      token: res['token'],
      userId: res['user']['id'],
      phone: res['user']['phone'],
      activeChildId: res['user']['activeChildId'],
    );
  }

  static Future<void> forgotPassword(String phone) async {
    await post('/api/auth/forgot-password', {'phone': phone});
  }

  static Future<void> verifyOtp(String phone, String otp) async {
    await post('/api/auth/verify-otp', {'phone': phone, 'otp': otp});
  }

  static Future<void> resetPassword(
    String phone,
    String otp,
    String newPassword,
  ) async {
    await post('/api/auth/reset-password', {
      'phone': phone,
      'otp': otp,
      'newPassword': newPassword,
    });
  }

  static void _checkStatus(http.Response res) {
    if (res.statusCode >= 400) {
      String msg = 'Lỗi ${res.statusCode}';
      try {
        final body = jsonDecode(res.body);
        msg = body['message'] ?? msg;
      } catch (_) {}
      throw Exception(msg);
    }
  }
}
