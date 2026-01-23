import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (email == 'student@fpt.edu.vn' && password == '123456') {
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      isLoading = false;
      errorMessage = 'Invalid email or password';
      notifyListeners();
      return false;
    }
  }
}
