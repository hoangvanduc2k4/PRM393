import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../notification_detail_screen.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.content,
    required this.time,
    required this.date,
    this.isImportant = false,
  });

  final String title;
  final String content;
  final String time;
  final String date;
  final bool isImportant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetailScreen(
            title: title,
            content: content,
            time: time,
            date: date,
          ),
        ),
      ),
      child: Container(
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
          border: Border.all(
            color: isImportant ? Colors.red.withOpacity(0.3) : Colors.grey.shade100,
            width: isImportant ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon + Title + Date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isImportant ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isImportant ? Iconsax.warning_2 : Iconsax.notification,
                    size: 20,
                    color: isImportant ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium!.apply(fontWeightDelta: 2),
                      ),
                      Text(
                        "$time - $date",
                        style: Theme.of(context).textTheme.labelSmall!.apply(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (isImportant)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "QUAN TRỌNG",
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            // Content preview removed as per user request (Leaf node)
          ],
        ),
      ),
    );
  }
}
