import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/common/widgets/app_button.dart';
import 'package:myfschools/common/widgets/app_text_field.dart';
import 'package:myfschools/common/widgets/common_app_bar.dart';
import 'package:myfschools/screens/forgot_password/new_password_screen.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import 'package:myfschools/utils/constants/colors.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                labelText: TTexts.otpLabel,
                prefixIcon: Iconsax.text_block,
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
              AppButton(
                text: TTexts.continueText,
                backgroundColor: TColors.primary,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
