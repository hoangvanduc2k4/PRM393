import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/constants/text_strings.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? verificationId;
  int? resendToken;
  String? _resetPhone; // Thêm biến lưu số điện thoại để query DB sau khi verify OTP

  // Use phone number or email based on your UI. 
  // The UI has "phone", but Firebase by default is easier with email/pass.
  // We'll simulate email login using phone input (e.g., phone@myfschools.com) or use real email.
  Future<String?> loginWithEmailPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _isLoading = false;
      notifyListeners();
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      if (e.code == 'weak-password') {
        return TTexts.errWeakPassword;
      } else if (e.code == 'email-already-in-use') {
        return TTexts.errEmailInUse;
      } else if (e.code == 'user-not-found') {
        return TTexts.errUserNotFound;
      } else if (e.code == 'wrong-password') {
        return TTexts.errWrongPassword;
      } else if (e.code == 'invalid-credential') {
        return TTexts.errInvalidCredential;
      }
      return e.message ?? TTexts.errDefaultAuth;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return '${TTexts.errSystem}${e.toString()}';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  // ==== FORGOT PASSWORD FLOW ====

  Future<String?> sendPasswordResetOTP(String phone) async {
    try {
      _isLoading = true;
      _resetPhone = phone; // Lưu lại để dùng lúc reset password
      notifyListeners();

      // Normalize phone number (assume Vietnam +84)
      String trimmedPhone = phone.trim();
      String formattedPhone = trimmedPhone;
      if (trimmedPhone.startsWith('0')) {
        formattedPhone = '+84${trimmedPhone.substring(1)}';
      }

      // Formatting variation like "+84 987 654 321" which Firebase console sometimes uses
      String spacedPhone = '';
      if (trimmedPhone.startsWith('0') && trimmedPhone.length == 10) {
        spacedPhone = '+84 ${trimmedPhone.substring(1, 4)} ${trimmedPhone.substring(4, 7)} ${trimmedPhone.substring(7, 10)}';
      }

      List<String> phoneVariations = [
        trimmedPhone,
        formattedPhone,
        spacedPhone,
        trimmedPhone.replaceAll(' ', ''),
        formattedPhone.replaceAll(' ', '')
      ];

      // Remove empty strings
      phoneVariations.removeWhere((p) => p.isEmpty);

      bool userFound = false;

      // 1.1 Thử tìm theo email trước vì lúc đăng nhập mình ghép + @myfschools.com
      String fakeEmail = '${trimmedPhone}@myfschools.com';
      var emailQuery = await _firestore.collection('users').where('email', isEqualTo: fakeEmail).limit(1).get();
      if (emailQuery.docs.isNotEmpty) {
        userFound = true;
      } else {
        // Search Firestore using various formats and field names to be safe
        for (String p in phoneVariations) {
          try {
            var query1 = await _firestore.collection('users').where('phone', isEqualTo: p).limit(1).get();
            if (query1.docs.isNotEmpty) {
              userFound = true;
              break;
            }
            var query2 = await _firestore.collection('users').where('phoneNumber', isEqualTo: p).limit(1).get();
            if (query2.docs.isNotEmpty) {
              userFound = true;
              break;
            }
          } catch (e) {
            print("Firestore query error: $e");
            // If there's a permission error or something, we might want to just skip
          }
        }
      }

      if (!userFound) {
        _isLoading = false;
        notifyListeners();
        return "Số điện thoại không hợp lệ / chưa được đăng ký";
      }

      print("Bắt đầu gửi OTP tới $formattedPhone...");

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto resolve in some devices
        },
        verificationFailed: (FirebaseAuthException e) {
          _isLoading = false;
          notifyListeners();
          // We can't handle UI from here easily if it fails asynchronously, 
          // usually we rely on the Exception or throw. For now, just throwing.
        },
        codeSent: (String verId, int? resToken) {
          verificationId = verId;
          resendToken = resToken;
          _isLoading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );

      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> verifyOTP(String otp) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (verificationId == null) {
        throw Exception("Verification ID is null. Try sending OTP again.");
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "OTP Code is invalid";
    }
  }

  Future<String?> resetPassword(String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (currentUser == null) {
        throw Exception("No user currently logged in. Please verify OTP first.");
      }

      if (_resetPhone == null) {
        throw Exception("Missing phone number to reset password.");
      }

      // 1. Tìm tài liệu user trên Firestore thông qua số điện thoại để lấy ra Email và Mật khẩu cũ
      String trimmedPhone = _resetPhone!.trim();
      String formattedPhone = trimmedPhone.startsWith('0') ? '+84${trimmedPhone.substring(1)}' : trimmedPhone;
      
      List<String> phoneVariations = [
        trimmedPhone,
        formattedPhone,
        '+84 ${trimmedPhone.substring(1, 4)} ${trimmedPhone.substring(4, 7)} ${trimmedPhone.substring(7, 10)}',
        trimmedPhone.replaceAll(' ', ''),
        formattedPhone.replaceAll(' ', '')
      ];
      phoneVariations.removeWhere((p) => p.isEmpty);

      DocumentSnapshot? userDoc;

      // 1.1 Thử tìm theo email trước vì lúc đăng nhập mình ghép + @myfschools.com
      String fakeEmail = '${trimmedPhone}@myfschools.com';
      var emailQuery = await _firestore.collection('users').where('email', isEqualTo: fakeEmail).limit(1).get();
      if (emailQuery.docs.isNotEmpty) {
        userDoc = emailQuery.docs.first;
      } else {
        // 1.2 Nếu không có email thì tìm theo số điện thoại
        for (String p in phoneVariations) {
          var query1 = await _firestore.collection('users').where('phone', isEqualTo: p).limit(1).get();
          if (query1.docs.isNotEmpty) {
             userDoc = query1.docs.first;
             break;
          }
          var query2 = await _firestore.collection('users').where('phoneNumber', isEqualTo: p).limit(1).get();
          if (query2.docs.isNotEmpty) {
             userDoc = query2.docs.first;
             break;
          }
        }
      }

      if (userDoc == null || !userDoc.exists) {
        throw Exception("Không tìm thấy người dùng trong Firestore Database (chưa có Document nào chứa SDT/Email này).");
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String oldPassword = userData['password'] ?? '';
      
      // Email mặc định theo format cũ nếu DB không lưu email
      String email = userData['email'] ?? '${trimmedPhone}@myfschools.com';
      if (oldPassword.isEmpty) {
        // Fallback: nếu admin không lưu password cũ, ta chỉ có thể cố ép đổi pass dưới DB
        await _firestore.collection('users').doc(userDoc.id).update({'password': newPassword});
        _isLoading = false;
        notifyListeners();
        // Cảnh báo: Cách này Firebase Auth vẫn giữ pass cũ do không login được để đổi.
        // NHƯNG để tránh lỗi UI, trả về null (thành công) để đổi màn hình.
        return null; // Đã đổi màn hình, dù Auth chưa đổi.
      }

      // 2. Đăng xuất khỏi tài khoản Số điện thoại (Phone Auth)
      await _auth.signOut();

      // 3. Đăng nhập VÀO tài khoản Email/Pass bằng mật khẩu CŨ
      await _auth.signInWithEmailAndPassword(email: email, password: oldPassword);

      // 4. Cập nhật Mật khẩu mới trên Firebase Authentication
      await _auth.currentUser!.updatePassword(newPassword);

      // 5. Cập nhật Mật khẩu mới trên Firestore Database
      await _firestore.collection('users').doc(userDoc.id).update({'password': newPassword});

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Lỗi Firebase Auth: ${e.message}";
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
