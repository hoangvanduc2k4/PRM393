import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormModel {
  final String id;
  final String title;
  final String type;
  final String date;
  final String reason;
  final String status;
  final Timestamp createdAt;

  FormModel({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  factory FormModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    
    // Ánh xạ trạng thái từ Tiếng Anh sang Tiếng Việt hiển thị
    String getVietnameseStatus(String engStatus) {
      switch (engStatus) {
        case 'Pending': return 'Chờ duyệt';
        case 'Approved': return 'Đã duyệt';
        case 'Rejected': return 'Từ chối';
        case 'Draft': return 'Bản nháp';
        case 'Expired': return 'Đã hết hạn';
        default: return engStatus;
      }
    }

    // Xử lý hiển thị ngày tháng
    String rawDate = data['date'] ?? '';
    String displayDate = rawDate;
    Timestamp created = data['createdAt'] ?? data['submittedAt'] ?? Timestamp.now();

    try {
      if (rawDate.contains('T')) {
        // Nếu là dữ liệu seed (ISO8601), chuyển sang dd/MM/yyyy và lấy làm mốc sắp xếp
        DateTime dt = DateTime.parse(rawDate);
        displayDate = DateFormat('dd/MM/yyyy').format(dt);
        if (data['createdAt'] == null) {
          created = Timestamp.fromDate(dt);
        }
      }
    } catch (e) {
      // Bỏ qua lỗi parse
    }

    return FormModel(
      id: doc.id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      date: displayDate,
      reason: data['reason'] ?? '',
      status: getVietnameseStatus(data['status'] ?? 'Pending'),
      createdAt: created,
    );
  }
}

class FormController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<FormModel> _forms = [];
  List<FormModel> get forms => _forms;

  String _currentChildId = "SOO1";
  String get currentChildId => _currentChildId;

  FormController() {
    fetchForms();
  }

  Future<void> fetchForms() async {
    try {
      _isLoading = true;
      notifyListeners();

      User? user = _auth.currentUser;
      if (user != null) {
        // Fetch user document to get activeChildId and children data
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          
          // Lấy activeChildId
          String? activeChildId = userData['activeChildId'];

          var childrenData = userData['children'] ?? userData['chidren']; // Corrected to use userData
          if (childrenData != null) {
            Map<String, dynamic> childrenMap = childrenData as Map<String, dynamic>;
            if (childrenMap.isNotEmpty) {
              var keys = childrenMap.keys.toList()..sort();
              
              if (activeChildId != null && keys.contains(activeChildId)) {
                 _currentChildId = activeChildId;
              } else {
                 _currentChildId = keys.first; 
              }
            }
          }
        }

        QuerySnapshot query = await _firestore
            .collection('forms')
            .where('userId', isEqualTo: user.uid)
            .where('childId', isEqualTo: _currentChildId)
            .get();

        _forms = query.docs.map((doc) => FormModel.fromFirestore(doc)).toList();
        
        // Sắp xếp local theo ngày tạo giảm dần (mới nhất lên đầu)
        _forms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      print("Error fetching forms: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> submitForm({required String type, required String reason, required String date}) async {
    try {
      _isLoading = true;
      notifyListeners();

      User? user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      // We use 'type' as title for simplicity, or hardcode it
      String title = type.startsWith("Xin ") ? "Đơn ${type.toLowerCase()}" : "Đơn từ";

      await _firestore.collection('forms').add({
        'userId': user.uid,
        'childId': _currentChildId,
        'title': title,
        'type': type,
        'reason': reason,
        'date': date,
        'status': 'Chờ duyệt',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Refresh list
      await fetchForms();
      
      return null; // Success
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
