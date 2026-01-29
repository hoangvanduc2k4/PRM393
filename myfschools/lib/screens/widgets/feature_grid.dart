import 'package:flutter/material.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/constants/app_colors.dart';
import '../score_screen.dart';
import '../timetable_screen.dart';
import '../attendance_screen.dart';
import '../student_profile_screen.dart';
import '../request_screen.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {'icon': Icons.assignment_outlined, 'label': 'Đơn từ', 'color': Colors.purple, 'page': const RequestScreen()},
      {'icon': Icons.contact_phone_outlined, 'label': 'Liên lạc', 'color': Colors.blue, 'page': null},
      {'icon': Icons.calendar_today_outlined, 'label': 'Thời khóa biểu', 'color': Colors.redAccent, 'page': TimetableScreen()},
      {'icon': Icons.bar_chart_rounded, 'label': 'Bảng điểm', 'color': Colors.lightBlue, 'page': ScoreScreen()},
      {'icon': Icons.how_to_reg_outlined, 'label': 'Điểm danh', 'color': Colors.green, 'page': AttendanceScreen()},
      {'icon': Icons.payment_outlined, 'label': 'Học phí', 'color': Colors.teal, 'page': null},
      {'icon': Icons.emoji_events_outlined, 'label': 'Sự kiện', 'color': Colors.orangeAccent, 'page': null},
      {'icon': Icons.groups_outlined, 'label': 'Câu lạc bộ', 'color': Colors.deepOrange, 'page': null},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tiện ích",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8, 
            ),
            itemBuilder: (context, index) {
              final item = features[index];
              return _buildFeatureItem(
                context, 
                item['icon'], 
                item['label'], 
                item['color'], 
                item['page']
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label, Color color, Widget? page) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        } else {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$label coming soon!")));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
             child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
