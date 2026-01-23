import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_colors.dart';
import '../../common/widgets/section_title.dart';
import '../../common/widgets/loading_indicator.dart';
import 'notifications_screen.dart';
import 'score_screen.dart';
import 'timetable_screen.dart';
import 'attendance_screen.dart';
import 'student_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => StudentProfileScreen()));
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const LoadingIndicator();
          }
          final student = _controller.student;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (student != null)
                  Card(
                    color: AppColors.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.p16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(student.avatarUrl),
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello, ${student.name}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                student.id,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                SectionTitle(title: "Utilities"),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildMenuCard(context, Icons.score, AppStrings.scores, Colors.orange, ScoreScreen()),
                    _buildMenuCard(context, Icons.calendar_today, AppStrings.timetable, Colors.blue, TimetableScreen()),
                    _buildMenuCard(context, Icons.check_circle_outline, AppStrings.attendance, Colors.green, AttendanceScreen()),
                    _buildMenuCard(context, Icons.person_outline, AppStrings.profile, Colors.purple, StudentProfileScreen()),
                  ],
                ),
                const SizedBox(height: 24),
                SectionTitle(title: "Recent Notifications"),
                const SizedBox(height: 8),
                if (_controller.recentNotifications.isEmpty)
                  const Text("No new notifications")
                else
                  ..._controller.recentNotifications.map(
                    (n) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.notifications_active, color: AppColors.primary),
                        title: Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(n.date.toString().substring(0, 10)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String label, Color color, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
