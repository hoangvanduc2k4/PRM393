import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'otp_screen.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/common_app_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ApiService.forgotPassword(phone);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(phone: phone)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                'Nhập số điện thoại của bạn để nhận mã OTP xác minh.',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(text: 'Tiếp tục', onPressed: _submit),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Center(child: Text('Quay lại đăng nhập')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
