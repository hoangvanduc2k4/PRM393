import 'package:flutter/material.dart';
import '../../controllers/student_profile_controller.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/constants/app_colors.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/app_button.dart';
import 'login_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  StudentProfileScreen({Key? key}) : super(key: key);

  final StudentProfileController _controller = StudentProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const LoadingIndicator();
          }
          final student = _controller.student;
          if (student == null) {
            return const Center(child: Text('Error loading profile'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p24),
            child: Column(
              children: [
                 CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(student.avatarUrl),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 16),
                Text(
                  student.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  student.id,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                _buildInfoTile(Icons.email, "Email", student.email),
                const Divider(),
                _buildInfoTile(Icons.school, "Major", student.major),
                const Divider(),
                const SizedBox(height: 48),
                AppButton(
                  text: AppStrings.logout,
                  backgroundColor: Colors.redAccent,
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
