import 'package:flutter/material.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizes.dart';
import '../../common/widgets/app_text_field.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _verifyAndReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;

      if (_otpController.text == "1234") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successfully! Login now.")),
        );
        // Pop back to login (pop until first route usually, or just pop otp and forgot)
        Navigator.popUntil(context, (route) => route.isFirst); 
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP (Try 1234)")),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Enter OTP"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Code sent to ${widget.phoneNumber}",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              
              // OTP Input
              AppTextField(
                label: "OTP Code",
                controller: _otpController,
                keyboardType: TextInputType.number,
                validator: (val) => val != null && val.isNotEmpty ? null : 'Required',
              ),
              const SizedBox(height: 16),
              
              // New Password
              AppTextField(
                label: "New Password",
                controller: _newPassController,
                obscureText: true,
                validator: (val) => val != null && val.length >= 6 ? null : 'Min 6 chars',
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyAndReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify & Reset", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
