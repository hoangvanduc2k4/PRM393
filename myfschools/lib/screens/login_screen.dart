import 'package:flutter/material.dart';
import '../../controllers/login_controller.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/constants/app_strings.dart';
// import '../../utils/validators/email_validator.dart'; // No longer needed
import '../../utils/validators/password_validator.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController _controller = LoginController();
  // Using Phone number now
  final TextEditingController _phoneController = TextEditingController(text: '0123456789');
  final TextEditingController _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p24),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo / Icon
                      const Icon(
                        Icons.school_rounded,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      
                      // App Name
                      const Text(
                        "School Portal",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Smart Link. Strong Home-School",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Phone Input
                      AppTextField(
                        label: "Phone number",
                        controller: _phoneController,
                        prefixIcon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      AppTextField(
                        label: AppStrings.password,
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validator: PasswordValidator.validate,
                      ),
                      
                      const SizedBox(height: 16),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _controller.rememberMe,
                                activeColor: AppColors.primary,
                                onChanged: (val) {
                                  _controller.toggleRememberMe(val ?? false);
                                },
                              ),
                              const Text("Remember Me?"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                              );
                            },
                            child: const Text(
                              AppStrings.forgotPassword,
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),

                      // Error Message
                      if (_controller.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            _controller.errorMessage!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _controller.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await _controller.login(
                                      _phoneController.text,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _controller.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  AppStrings.login,
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
