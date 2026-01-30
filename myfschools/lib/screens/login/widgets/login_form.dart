import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myfschools/screens/home/home.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../forgot_password/forgot_password.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            ///Phone
            AppTextField(
              labelText: TTexts.phone,
              prefixIcon: Iconsax.mobile,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            ///Password
            AppTextField(
              labelText: TTexts.password,
              prefixIcon: Iconsax.password_check,
              obscureText: true,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            ///Remember me & forgot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Remember me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(TTexts.tRememberMe),
                  ],
                ),

                ///Forgot password
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  ),
                  child: const Text(TTexts.tForgetPassword),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            ///Sign in button
             AppButton(
              text: TTexts.signIn,
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
