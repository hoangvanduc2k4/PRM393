import 'package:flutter/material.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';

import '../../common/widgets/app_button.dart';
import '../../common/widgets/common_app_bar.dart';

/// Forgot Password — OTP qua Firebase đã bị loại bỏ.
/// Hiện tại hiển thị hướng dẫn liên hệ admin để reset mật khẩu.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: TTexts.forgotPasswordTitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.spaceBtwSections),
              const Icon(Icons.lock_reset, size: 64, color: Colors.orange),
              const SizedBox(height: TSizes.spaceBtwSections),
              const Text(
                'Quên mật khẩu?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text(
                'Để đặt lại mật khẩu, vui lòng liên hệ với ban quản lý nhà trường hoặc bộ phận IT để được hỗ trợ.',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              AppButton(
                text: 'Quay lại đăng nhập',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
