import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/common/widgets/app_button.dart';
import 'package:myfschools/common/widgets/app_text_field.dart';
import 'package:myfschools/common/widgets/common_app_bar.dart';
import 'package:myfschools/utils/constants/sizes.dart';
import 'package:myfschools/utils/constants/text_strings.dart';
import 'package:myfschools/utils/constants/colors.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

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
                labelText: TTexts.newPassword,
                prefixIcon: Iconsax.lock,
                obscureText: true,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// 2. Confirm Password Field
              AppTextField(
                labelText: TTexts.confirmPassword,
                prefixIcon: Iconsax.lock,
                obscureText: true,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
        
              /// 3. Submit Button
              AppButton(
                text: TTexts.submit,
                backgroundColor: TColors.primary,
                onPressed: () {
                  // Pop all screens until we reach the first screen (Login)
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
