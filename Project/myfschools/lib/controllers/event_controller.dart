import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';

class EventController extends ChangeNotifier {
  List<EventModel> _events = [];
  bool _isLoading = false;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;

  EventController() {
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await ApiService.get('/api/events') as List<dynamic>;
      _events = data.map((e) => EventModel.fromApi(e)).toList();

      // Sắp xếp sự kiện theo EventDate giảm dần (mới nhất lên đầu)
      _events.sort((a, b) => b.eventDate.compareTo(a.eventDate));
    } catch (e) {
      debugPrint("Lỗi tải sự kiện: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
