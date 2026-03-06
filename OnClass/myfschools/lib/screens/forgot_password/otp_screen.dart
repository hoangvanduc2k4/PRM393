import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/common/widgets/app_button.dart';
import 'package:myfschools/common/widgets/app_text_field.dart';
import 'package:myfschools/common/widgets/common_app_bar.dart';
import 'package:myfschools/screens/forgot_password/new_password_screen.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import 'package:myfschools/utils/constants/colors.dart';
import '../../controllers/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  final AuthController authController;
  
  const OtpScreen({super.key, required this.authController});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mã OTP'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await widget.authController.verifyOTP(otp);

    setState(() => _isLoading = false);

    if (error == null) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewPasswordScreen(authController: widget.authController)),
      );
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
      appBar: const CommonAppBar(title: TTexts.verificationTitle),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// 1. Headings
              Text(
                TTexts.otpMessage,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// 2. OTP Field
              AppTextField(
                controller: _otpController,
                labelText: TTexts.otpLabel,
                prefixIcon: Iconsax.text_block,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// 2. Resend Text Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    TTexts.otpResendPrompt,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      TTexts.resend,
                      style: const TextStyle(
                        color: Colors.red, // Design shows red/orange, using red as clearer distinction or primary
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// 3. Next Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                      text: TTexts.continueText,
                      backgroundColor: TColors.primary,
                      onPressed: _handleVerifyOTP,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
