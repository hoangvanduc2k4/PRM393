import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      // Lấy toàn bộ sự kiện từ DB (Sự kiện thường là public cho toàn trường)
      QuerySnapshot query = await _firestore.collection('events').get();

      _events = query.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
      
      // Sắp xếp tay: Sự kiện sắp diễn ra lên đầu (Gần nhất trong tương lai)
      // Sort theo ngày của sự kiện (ưu tiên ngày sự kiện ở gần hiện tại nhất)
      _events.sort((a, b) => b.eventDate.compareTo(a.eventDate));

    } catch (e) {
      print("Lỗi tải sự kiện: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
