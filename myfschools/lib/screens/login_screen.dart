import 'package:flutter/material.dart';
import '../../controllers/login_controller.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/validators/email_validator.dart';
import '../../utils/validators/password_validator.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController _controller = LoginController();
  final TextEditingController _emailController = TextEditingController(text: 'student@fpt.edu.vn');
  final TextEditingController _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        isDark ? Icons.school_outlined : Icons.school,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Welcome back, Student!",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    AppTextField(
                      label: AppStrings.email,
                      controller: _emailController,
                      validator: EmailValidator.validate,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: AppStrings.password,
                      controller: _passwordController,
                      obscureText: true,
                      validator: PasswordValidator.validate,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                          );
                        },
                        child: const Text(AppStrings.forgotPassword),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_controller.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _controller.errorMessage!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    AppButton(
                      text: AppStrings.login,
                      isLoading: _controller.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await _controller.login(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (success && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
