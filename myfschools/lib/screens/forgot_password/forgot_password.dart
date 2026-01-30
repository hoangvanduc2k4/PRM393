import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/screens/forgot_password/otp_screen.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import 'package:myfschools/utils/constants/colors.dart';

import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/common_app_bar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                labelText: TTexts.phone,
                prefixIcon: Iconsax.mobile,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// 3. Submit Button
              AppButton(
                text: TTexts.continueText,
                backgroundColor: TColors.primary,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtpScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
