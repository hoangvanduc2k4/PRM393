import 'package:flutter/material.dart';
import '../../models/attendance_timeline_model.dart';
import '../../utils/constants/app_colors.dart';

class AttendanceTimelineItem extends StatelessWidget {
  final AttendanceTimelineModel item;

  const AttendanceTimelineItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column
          SizedBox(
            width: 50,
            child: Text(
              item.startTime,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), // Light green background
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(
                         child: Text(
                           item.courseName,
                           style: const TextStyle(
                             color: Color(0xFF1B5E20), // Dark green
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Text(
                           item.status,
                           style: const TextStyle(
                             color: Colors.green,
                             fontSize: 12,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       )
                     ],
                   ),
                   const SizedBox(height: 12),
                   
                   // Time and Room Row
                   Row(
                     children: [
                       const Icon(Icons.access_time, size: 16, color: Colors.green),
                       const SizedBox(width: 4),
                       Text(
                         "${item.startTime} - ${item.endTime}",
                         style: TextStyle(color: Colors.green[800], fontSize: 13),
                       ),
                       const SizedBox(width: 24),
                       const Icon(Icons.door_back_door_outlined, size: 16, color: Colors.green), // closest icon to door
                        const SizedBox(width: 4),
                       // Design implies room icon + nothing specific mentioned, let's just make icon green
                     ],
                   ),
                   
                   const SizedBox(height: 12),
                   
                   // Lecturer Row
                   Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1B5E20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 12),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "GV: ${item.lecturer}",
                           style: TextStyle(color: Colors.green[800], fontSize: 13),
                        )
                      ],
                   )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
