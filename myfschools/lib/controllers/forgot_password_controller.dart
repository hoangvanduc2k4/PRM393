import 'package:flutter/material.dart';

class ForgotPasswordController extends ChangeNotifier {
  bool isLoading = false;
  String? successMessage;
  String? errorMessage;

  Future<void> sendResetLink(String email) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    isLoading = false;
    successMessage = 'Password reset link has been sent to your email';
    notifyListeners();
  }
}
