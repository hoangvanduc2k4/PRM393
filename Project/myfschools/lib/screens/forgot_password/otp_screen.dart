import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'new_password_screen.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/common_app_bar.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mã OTP 6 chữ số')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ApiService.verifyOtp(widget.phone, otp);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NewPasswordScreen(phone: widget.phone, otp: otp),
        ),
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
      appBar: const CommonAppBar(title: 'Xác minh OTP'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.spaceBtwSections),
              const Icon(Icons.mark_email_read, size: 64, color: Colors.blue),
              const SizedBox(height: TSizes.spaceBtwSections),
              const Text(
                'Nhập mã OTP',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'Mã OTP đã được gửi đến số điện thoại ${widget.phone}. Vui lòng kiểm tra và nhập vào bên dưới.',
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Mã OTP',
                  prefixIcon: Icon(Icons.security),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(text: 'Xác minh', onPressed: _verify),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Center(child: Text('Gửi lại mã')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
