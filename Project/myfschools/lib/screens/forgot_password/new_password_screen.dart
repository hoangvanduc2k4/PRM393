import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/common_app_bar.dart';

class NewPasswordScreen extends StatefulWidget {
  final String phone;
  final String otp;
  const NewPasswordScreen({super.key, required this.phone, required this.otp});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ mật khẩu')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mật khẩu không khớp')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ApiService.resetPassword(widget.phone, widget.otp, password);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đổi mật khẩu thành công!')));

      // Pop back to Login screen (which should be the 3rd screen back: NewPassword -> OTP -> ForgotPassword -> Login)
      Navigator.of(context).popUntil((route) => route.isFirst);
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
      appBar: const CommonAppBar(title: 'Đặt lại mật khẩu'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.spaceBtwSections),
              const Icon(Icons.lock_outline, size: 64, color: Colors.green),
              const SizedBox(height: TSizes.spaceBtwSections),
              const Text(
                'Tạo mật khẩu mới',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text(
                'Vui lòng nhập mật khẩu mới cho tài khoản của bạn.',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  prefixIcon: Icon(Icons.password),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  prefixIcon: Icon(Icons.password),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(text: 'Đổi mật khẩu', onPressed: _reset),
            ],
          ),
        ),
      ),
    );
  }
}
