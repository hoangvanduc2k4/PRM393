import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/constants/app_colors.dart';
import 'widgets/student_info_card.dart';
import 'widgets/feature_grid.dart';
import 'attendance_screen.dart';
import 'student_profile_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of screens for bottom navigation
    // List of screens for bottom navigation
    final List<Widget> _screens = [
      _buildHomeContent(),     // Trang chủ
      StudentProfileScreen(),  // Tôi
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Use safe area for top padding
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Chào buổi tối", // This could be dynamic based on time
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, size: 28),
                        onPressed: () {},
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none, size: 28),
                            onPressed: () {
                               Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
                            },
                          ),
                          if (_controller.recentNotifications.isNotEmpty)
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Student Card
                StudentInfoCard(student: _controller.student),
                const SizedBox(height: 24),
                // Feature Grid
                const FeatureGrid(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
