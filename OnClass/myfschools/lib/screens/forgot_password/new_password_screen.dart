import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/common/widgets/app_button.dart';
import 'package:myfschools/common/widgets/app_text_field.dart';
import 'package:myfschools/common/widgets/common_app_bar.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import 'package:myfschools/utils/constants/colors.dart';
import '../../controllers/auth_controller.dart';

class NewPasswordScreen extends StatefulWidget {
  final AuthController authController;
  
  const NewPasswordScreen({super.key, required this.authController});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin'), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không khớp'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await widget.authController.resetPassword(password);

    setState(() => _isLoading = false);

    if (error == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thành công'), backgroundColor: Colors.green),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: TTexts.setNewPasswordTitle),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          

              const SizedBox(height: TSizes.spaceBtwSections),

              /// 2. New Password Field
              AppTextField(
                controller: _passwordController,
                labelText: TTexts.newPassword,
                prefixIcon: Iconsax.lock,
                obscureText: true,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// 2. Confirm Password Field
              AppTextField(
                controller: _confirmPasswordController,
                labelText: TTexts.confirmPassword,
                prefixIcon: Iconsax.lock,
                obscureText: true,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
        
              /// 3. Submit Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                      text: TTexts.submit,
                      backgroundColor: TColors.primary,
                      onPressed: _handleResetPassword,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
