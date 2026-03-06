import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/screens/forgot_password/otp_screen.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import 'package:myfschools/utils/constants/colors.dart';

import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/common_app_bar.dart';
import '../../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthController _authController = AuthController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _authController.dispose();
    super.dispose();
  }

  void _handleSendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authController.sendPasswordResetOTP(phone);

    setState(() => _isLoading = false);

    if (error == null) {
      if (!mounted) return;
      // Pass the controller so we can use the same verificationId, or pass the phone number
      // Assuming OtpScreen also initiates its own AuthController but we need verificationId.
      // Wait, let's pass the AuthController itself to OtpScreen, or just store verificationId 
      // globally/in Provider. The current code instantiates new AuthController which 
      // loses `verificationId`. We need to pass it or make AuthController global.
      // Easiest is to pass the phone and existing authController instance.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(authController: _authController)),
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
    // Scaffold provides the basic visual structure (app bar, body, background)
    return Scaffold(
      appBar: const CommonAppBar(title: TTexts.forgotPasswordTitle),

      // SingleChildScrollView ensures the content is scrollable when keywords appear
      body: SingleChildScrollView(
        child: Padding(
          // Use consistent padding from TSizes
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1. Headings
   Text(
  TTexts.forgotPasswordSubTitle,
  style: const TextStyle(
    fontSize: 18,     
    color: Colors.black,
  ),
),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// 2. Text field (Phone Number)
              AppTextField(
                controller: _phoneController,
                labelText: TTexts.phone,
                prefixIcon: Iconsax.mobile,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// 3. Submit Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                      text: TTexts.continueText,
                      backgroundColor: TColors.primary,
                      onPressed: _handleSendOTP,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
