import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  NotificationController() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Lấy tất cả thông báo của user (phụ huynh) này
        QuerySnapshot query = await _firestore
            .collection('notifications')
            .where('userId', isEqualTo: currentUser.uid)
            .get();

        _notifications = query.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
        
        // Sắp xếp tay: Giảm dần theo thời gian (mới nhất lên đầu)
        _notifications.sort((a, b) => b.createdAtUTC.compareTo(a.createdAtUTC));
      }
    } catch (e) {
      print("Lỗi tải thông báo: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm chuyển trạng thái chưa đọc -> đã đọc
  Future<void> markAsRead(String notificationId) async {
    int index = _notifications.indexWhere((note) => note.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      // 1. Đổi UI ngay lập tức
      _notifications[index].isRead = true;
      notifyListeners();

      try {
        // 2. Cập nhật Firebase
        await _firestore.collection('notifications').doc(notificationId).update({
          'isRead': true,
        });
      } catch (e) {
        print("Lỗi đánh dấu đã đọc: $e");
        // Nếu lỗi thì quay lại trạng thái cũ
        _notifications[index].isRead = false;
        notifyListeners();
      }
    }
  }
}
