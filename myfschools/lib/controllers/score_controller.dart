import 'package:flutter/material.dart';
import '../models/score_model.dart';

class ScoreController extends ChangeNotifier {
  bool isLoading = true;
  List<ScoreModel> scores = [];

  ScoreController() {
    loadScores();
  }

  Future<void> loadScores() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    scores = ScoreModel.getMockData();
    
    isLoading = false;
    notifyListeners();
  }
}
