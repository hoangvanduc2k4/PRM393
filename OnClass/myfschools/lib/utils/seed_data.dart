import 'package:cloud_firestore/cloud_firestore.dart';

class SeedDataUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SEED HOÀN CHỈNH VỚI DỮ LIỆU THỰC TẾ
  static Future<void> seedMoreData() async {
    try {
      print("========== BẮT ĐẦU SEED HOÀN CHỈNH VỚI DỮ LIỆU THỰC TẾ ==========");

      // ==================== USER & 2 ĐỨA CON ====================
      String parentUid = "5uwPT22Dx5hcvKxnCJ8FiqgxO513";

      String child1Id = "SOO1";
      Map<String, dynamic> child1Data = {
        "childId": child1Id,
        "childName": "Phạm Minh Khang",
        "className": "3A1",
        "avatarUrl": "https://ui-avatars.com/api/?name=Khang&background=random",
      };

      String child2Id = "SOO2";
      Map<String, dynamic> child2Data = {
        "childId": child2Id,
        "childName": "Phạm Thị Minh Anh",
        "className": "3A2",
        "avatarUrl": "https://ui-avatars.com/api/?name=Anh&background=random",
      };

      List<String> bothChildIds = [child1Id, child2Id];

      WriteBatch batch = _firestore.batch();

      // Cập nhật user (merge để không mất dữ liệu cũ)
      DocumentReference parentDocRef = _firestore.collection('users').doc(parentUid);
      batch.set(
        parentDocRef,
        {"children": {child1Id: child1Data, child2Id: child2Data}},
        SetOptions(merge: true),
      );

      // ==================== NOTIFICATIONS (15) ====================
      List<Map<String, String>> sampleNotifications = [
        {"title": "Nhắc nhở học phí", "message": "Kính gửi quý phụ huynh, kỳ hạn đóng học phí tháng 10 sắp đến. Vui lòng hoàn thành trước ngày 20/10.", "type": "Hệ thống"},
        {"title": "Kết quả bài kiểm tra", "message": "Điểm bài kiểm tra giữa kỳ môn Toán của bé Khang đã có. Phụ huynh vui lòng kiểm tra trong mục Điểm số.", "type": "Học tập"},
        {"title": "Thông báo nghỉ lễ", "message": "Nhà trường thông báo lịch nghỉ Lễ Quốc Khánh tự ngày 01/09 đến hết ngày 04/09. Chúc quý gia đình kỳ nghỉ vui vẻ.", "type": "Sự kiện"},
        {"title": "Hoạt động ngoại khóa", "message": "Cuối tuần này nhà trường tổ chức cho các bé đi dã ngoại tại Ba Vì. Phụ huynh đăng ký trước thứ 5.", "type": "Sự kiện"},
        {"title": "Sức khỏe định kỳ", "message": "Lịch khám sức khỏe định kỳ học kỳ 1 của học sinh sẽ diễn ra vào sáng thứ 3 tuần sau.", "type": "Nhà trường"},
        {"title": "Học phí xe tuyến", "message": "Phụ huynh lưu ý đóng phí xe đưa đón tháng 9 trước ngày 05/09.", "type": "Hệ thống"},
        {"title": "Thay đổi thời khóa biểu", "message": "Từ tuần sau, thời khóa biểu của lớp 3A1 sẽ có sự điều chỉnh. Lịch học mới đã được cập nhật.", "type": "Học tập"},
        {"title": "Xin phép vắng mặt", "message": "Giáo viên chủ nhiệm lớp 3A2 sẽ nghỉ phép trong 3 ngày tới, giáo viên dạy thay đã được sắp xếp.", "type": "Lớp học"},
        {"title": "Danh hiệu thi đua", "message": "Chúc mừng bé Minh Anh đã lọt top 5 học sinh xuất sắc nhất tuần vừa qua của khối 3.", "type": "Học tập"},
        {"title": "Mời họp phụ huynh", "message": "Kính mời quý phụ huynh đến dự buổi họp phụ huynh đầu năm học vào lúc 8h sáng Chủ Nhật.", "type": "Sự kiện"},
        {"title": "Câu lạc bộ mới", "message": "Mở đơn đăng ký Câu lạc bộ Lập trình Robot cho khối Tiểu học. Số lượng có hạn.", "type": "Học tập"},
        {"title": "Phản hồi nề nếp", "message": "Hôm nay bé Khang đã thực hiện rất tốt các nội quy học đường, cô giáo có lời khen ngợi.", "type": "Lớp học"},
        {"title": "Cảnh báo dịch bệnh", "message": "Bộ phận Y tế nhắc nhở phụ huynh chú ý giữ ấm cho con em trong thời tiết chuyển mùa để phòng tránh cảm cúm.", "type": "Nhà trường"},
        {"title": "Giao bài tập cuối tuần", "message": "Giáo viên môn Toán đã giao bài tập cuối tuần. Phụ huynh nhắc nhở bé hoàn thành.", "type": "Học tập"},
        {"title": "Thực đơn tuần sau", "message": "Thực đơn bữa trưa tuần sau đã được cập nhật trên hệ thống với nhiều món mới hấp dẫn.", "type": "Hệ thống"},
      ];

      for (int i = 0; i < sampleNotifications.length; i++) {
        final ref = _firestore.collection('notifications').doc();
        batch.set(ref, {
          "userId": parentUid,
          "title": sampleNotifications[i]['title'],
          "message": sampleNotifications[i]['message'],
          "type": sampleNotifications[i]['type'],
          "isRead": i > 5, // 5 thông báo đầu tiên là chưa đọc
          "createdAt": DateTime.now().subtract(Duration(days: i, hours: i * 2)).toIso8601String(),
        });
      }

      // ==================== SCHEDULES (50) ====================
      List<String> classNames = ["3A1", "3A2"];
      List<String> weekdays = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6"];
      List<Map<String, String>> scheduleSubjects = [
        {"sub": "Toán", "gv": "GV. Hoàng Thanh", "room": "P.301"},
        {"sub": "Tiếng Việt", "gv": "GV. Mai Lan", "room": "P.301"},
        {"sub": "Tiếng Anh", "gv": "GV. Mr. John", "room": "P.305"},
        {"sub": "Khoa học", "gv": "GV. Hải Đăng", "room": "P.Phòng TN"},
        {"sub": "Âm nhạc", "gv": "GV. Minh Khuê", "room": "P.Âm Nhạc"},
        {"sub": "Thể dục", "gv": "GV. Quốc Huy", "room": "Nhà Đa Năng"},
        {"sub": "Mỹ thuật", "gv": "GV. Thanh Hà", "room": "P.Mỹ Thuật"},
        {"sub": "Đạo đức", "gv": "GV. Mai Lan", "room": "P.301"},
      ];

      for (String cls in classNames) {
        for (String day in weekdays) {
          for (int slot = 1; slot <= 5; slot++) {
            final ref = _firestore.collection('schedules').doc();
            // Lấy ramdom 1 môn học theo công thức giả lập
            var s = scheduleSubjects[(slot * cls.length * day.length) % scheduleSubjects.length];
            batch.set(ref, {
              "className": cls,
              "dayOfWeek": day,
              "slot": slot,
              "subject": s['sub'],
              "teacher": s['gv'],
              "room": s['room'],
              "term": "Học kỳ 1 - 2026", // Khớp với _selectedTerm mặc định
            });
          }
        }
      }

      // ==================== GRADES (16) ====================
      List<String> gradeSubjects = ["Toán", "Tiếng Việt", "Tiếng Anh", "Khoa học", "Tự nhiên & XH", "Lịch sử", "Địa lý", "Tin học"];
      
      for (String cId in bothChildIds) {
        for (int i = 0; i < gradeSubjects.length; i++) {
          final ref = _firestore.collection('grades').doc();
          // Tạo điểm thực tế học sinh Tiểu Học
          double avg = 7.5 + (i * cId.length) % 2.5; // Điểm quanh quẩn 7.5 - 9.5
          
          batch.set(ref, {
            "childId": cId,
            "subject": gradeSubjects[i],
            "term": "Học kỳ 1 - 2026", // Khớp với UI mặc định
            "quiz1": avg + 0.5 > 10 ? 10 : avg + 0.5,
            "quiz2": avg - 0.5,
            "midterm": avg,
            "final": avg + 0.2,
            "average": avg,
            "status": "Passed",
          });
        }
      }

      // ==================== EVENTS (8) ====================
      List<Map<String, String>> realEvents = [
        {"name": "Dã Ngoại Làng Gốm Bát Tràng", "desc": "Trải nghiệm làm thợ gốm nhí và tìm hiểu văn hóa.", "loc": "Bát Tràng", "col": "blue"},
        {"name": "Ngày Hội Tư Vấn Sức Khỏe Mắt", "desc": "Khám mắt miễn phí và tư vấn chống cận thị học đường.", "loc": "Phòng Y Tế", "col": "green"},
        {"name": "Hội Chợ Sách Mùa Thu", "desc": "Giới thiệu hàng ngàn đầu sách thiếu nhi hấp dẫn.", "loc": "Thư Viện", "col": "orange"},
        {"name": "Giao Lưu Cựu Học Sinh OLYMPIA", "desc": "Trò chuyện cùng các anh chị sinh viên xuất sắc.", "loc": "Hội Trường D", "col": "purple"},
        {"name": "Giải Bóng Đá Thiếu Nhi F-League", "desc": "Khai mạc giải bóng đá tranh cúp F-League cấp trường.", "loc": "Sân Vận Động", "col": "red"},
        {"name": "Lễ Hội Hallowen - Trick or Treat", "desc": "Lễ hội hóa trang đáng mong chờ nhất tháng 10.", "loc": "Sân Trường", "col": "orange"},
        {"name": "Cuộc Thi Tài Năng Nhí Got Talent", "desc": "Vòng Chung Khảo tìm kiếm tài năng âm nhạc, múa, hát.", "loc": "Nhà Đa Năng", "col": "purple"},
        {"name": "Workshop Tiếng Anh Tương Tác", "desc": "Giao lưu cùng 100% giáo viên bản ngữ xoay quanh chủ đề Động Vật Khổng Lồ.", "loc": "Phòng Tiếng Anh", "col": "blue"},
      ];
      for (int i = 0; i < realEvents.length; i++) {
        final ref = _firestore.collection('events').doc();
        DateTime eventDate = DateTime.now().add(Duration(days: (i + 1) * 7)); // Sự kiện rải rác mỗi tuần 1 cái
        
        batch.set(ref, {
          "eventName": realEvents[i]['name'],
          "description": realEvents[i]['desc'],
          "date": eventDate.toIso8601String(),
          "time": "08:30 - 11:30",
          "location": realEvents[i]['loc'],
          "color": realEvents[i]['col'],
          "createdAt": FieldValue.serverTimestamp(),
          "imageUrl": "https://picsum.photos/seed/realevent$i/400/200",
        });
      }

      // ==================== CLUBS (6) ====================
      List<Map<String, String>> clubs = [
        {"name": "Khoa học Tên lửa Nhí", "cat": "Khoa học", "desc": "Khám phá vũ trụ và tự tay làm mô hình tên lửa nước."},
        {"name": "Bóng rổ F-Start", "cat": "Thể thao", "desc": "Rèn luyện thể lực và tinh thần đồng đội ném rổ."},
        {"name": "MC Nhí Tự Tin", "cat": "Kỹ năng", "desc": "Nâng cao kỹ năng thuyết trình trước đám đông."},
        {"name": "Toán Học Mathnasium", "cat": "Học thuật", "desc": "Học Toán qua mô hình và trò chơi trí tuệ Mỹ."},
        {"name": "Piano Cơ Bản", "cat": "Nghệ thuật", "desc": "Làm quen với nốt nhạc và các bản nhạc thiếu nhi."},
        {"name": "Lập trình Scratch", "cat": "Công nghệ", "desc": "Bước đầu làm quen tư duy lập trình kéo thả."},
      ];
      for (int i = 0; i < clubs.length; i++) {
        var c = clubs[i];
        final ref = _firestore.collection('clubs').doc();
        batch.set(ref, {
          "name": c["name"],
          "category": c["cat"],
          "memberCount": 20 + i * 12,
          "description": c["desc"],
          "joinedChildIds": i % 3 == 0 ? ["SOO1", "SOO2"] : (i % 3 == 1 ? ["SOO2"] : ["SOO1"]), // Tham gia thực tế hơn
        });
      }

      // ==================== FORMS (10 ĐƠN – ĐA TRẠNG THÁI) ====================
      List<Map<String, String>> realForms = [
        {"type": "Nghỉ ốm", "status": "Approved", "reason": "Cháu Khang bị sốt siêu vi cần nghỉ theo chỉ định bác sĩ."},
        {"type": "Xin vắng mặt", "status": "Pending", "reason": "Gia đình có việc về quê dự đám cưới người thân."},
        {"type": "Đơn xin học bù", "status": "Rejected", "reason": "Xin học bù môn Tiếng Anh buổi thứ 5 tuần trước."},
        {"type": "Nghỉ phép", "status": "Approved", "reason": "Đi khám răng định kỳ tại viện Răng Hàm Mặt."},
        {"type": "Xin đăng ký ăn bán trú", "status": "Approved", "reason": "Đăng ký thêm suất ăn trưa do mẹ bận đi công tác."},
        {"type": "Đơn xin chuyển lớp", "status": "Draft", "reason": "Xin chuyển qua lớp 3A3 để học cùng em họ."},
        {"type": "Nghỉ ốm", "status": "Pending", "reason": "Cháu Minh Anh bị đau bụng dạ dày vào sáng nay."},
        {"type": "Xin xe tuyến", "status": "Approved", "reason": "Xin đổi tuyến xe bus từ tuyến Mễ Trì sang tuyến Cầu Giấy."},
        {"type": "Nghỉ phép", "status": "Expired", "reason": "Xin nghỉ học buổi chiều tham gia ngoại khóa gia đình."},
        {"type": "Xin vắng mặt", "status": "Pending", "reason": "Gia đình có tang sự đột xuất."},
      ];

      for (int i = 0; i < realForms.length; i++) {
        String childId = bothChildIds[i % 2];
        var f = realForms[i];
        final ref = _firestore.collection('forms').doc();
        batch.set(ref, {
          "userId": parentUid,
          "childId": childId,
          "title": "Đơn xin ${f['type'].toString().toLowerCase()}",
          "type": f['type'],
          "reason": f['reason'],
          "date": DateTime.now().subtract(Duration(days: i * 4)).toIso8601String(),
          "status": f['status'],
          "submittedAt": FieldValue.serverTimestamp(),
          "reviewedAt": (f['status'] == "Approved" || f['status'] == "Rejected")
              ? DateTime.now().subtract(Duration(days: i * 2)).toIso8601String()
              : null,
        });
      }

      // ==================== VẪN GIỮ CÁC VÒNG LẶP TEACHERS VÀ ANNOUNCEMENTS KHÔNG QUÁ QUAN TRỌNG ĐỂ THÊM THỰC TẾ ====================

      await batch.commit();
      print("========== SEED HOÀN TẤT VỚI DATA THỰC TẾ ==========");
      print("User UID: $parentUid");
      print("2 đứa con: SOO1 & SOO2");

    } catch (e) {
      print("LỖI SEED: $e");
    }
  }
}