import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool rememberMe = false;

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  Future<bool> login(String phoneNumber, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock logic: Allow any phone/pass for ease of testing or specific one
    if (phoneNumber.isNotEmpty && password == '123456') {
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      isLoading = false;
      errorMessage = 'Invalid phone number or password';
      notifyListeners();
      return false;
    }
  }
}
