import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
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
  case TTexts.statusAttended:
    statusColor = const Color(0xFFCFF5E7); // Mint pastel (dễ nhìn)
    statusText = TTexts.statusAttended;
    break;

  case TTexts.statusAbsent:
    statusColor = const Color(0xFFFFE2E0); // Soft red/pink pastel
    statusText = TTexts.statusAbsent;
    break;

  default:
    statusColor = const Color(0xFFE6E9F0); // Light grey-blue neutral
    statusText = TTexts.statusUpcoming;
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
                  color: Colors.black, // Blue title
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
               Text("${TTexts.labelRoom} $room", style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Row 3: Teacher
          Row(
            children: [
              const Icon(Iconsax.user, size: 18, color: Colors.black87),
              const SizedBox(width: 8),
              Text("${TTexts.labelLecturer} $teacher", style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
