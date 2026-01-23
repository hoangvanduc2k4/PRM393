import 'package:flutter/material.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/validators/email_validator.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final ForgotPasswordController _controller = ForgotPasswordController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.forgotPassword)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter your email to receive a password reset link.'),
                  const SizedBox(height: 24),
                  AppTextField(
                    label: AppStrings.email,
                    controller: _emailController,
                    validator: EmailValidator.validate,
                  ),
                  const SizedBox(height: 24),
                  if (_controller.successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _controller.successMessage!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  AppButton(
                    text: 'Send Link',
                    isLoading: _controller.isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _controller.sendResetLink(_emailController.text);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
