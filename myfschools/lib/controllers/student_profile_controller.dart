import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentProfileController extends ChangeNotifier {
  bool isLoading = true;
  StudentModel? student;

  StudentProfileController() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    student = StudentModel.getMockData();
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    // Implement logout logic
    await Future.delayed(const Duration(milliseconds: 500));
    // Navigate back to login
    // In strict architecture, navigation might be handled by UI listening to a state
  }
}
