// NewPasswordScreen — không còn sử dụng (OTP flow đã bị loại bỏ cùng Firebase Auth).
// File được giữ lại để tránh lỗi import, nhưng không được navigate tới.
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class NewPasswordScreen extends StatelessWidget {
  final AuthController authController;
  const NewPasswordScreen({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
