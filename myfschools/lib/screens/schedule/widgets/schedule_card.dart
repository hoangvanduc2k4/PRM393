import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../common/styles/shadow_styles.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.subjectName,
    required this.room,
    required this.time,
    required this.teacher,
    required this.status, // "Attended", "Absent", "NotYet"
  });

  final String subjectName;
  final String room;
  final String time;
  final String teacher;
  final String status;

  @override
  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (status) {
      case "Attended":
        statusColor = const Color(0xFFD3EADD); // Light Green bg
        statusText = "Attended"; 
        break;
      case "Absent":
        statusColor = const Color(0xFFFAD7D7); // Light Red bg
        statusText = "Absent"; 
        break;
      default:
        statusColor = const Color(0xFFE0E0E0); // Light Grey bg
        statusText = "Upcoming"; 
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Subject Name + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subjectName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0054A6), // Blue title
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Row 2: Time + Room
          Row(
            children: [
              const Icon(Iconsax.clock, size: 18, color: Colors.black87),
              const SizedBox(width: 8),
              Text(time, style: const TextStyle(color: Colors.black54)),
              const SizedBox(width: TSizes.spaceBtwSections),
              const Icon(Iconsax.location, size: 18, color: Colors.black87),
              const SizedBox(width: 8),
               Text("Room: $room", style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Row 3: Teacher
          Row(
            children: [
              const Icon(Iconsax.user, size: 18, color: Colors.black87),
              const SizedBox(width: 8),
              Text("Lecturer: $teacher", style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
