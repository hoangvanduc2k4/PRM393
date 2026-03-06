import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class ClubCard extends StatelessWidget {
  const ClubCard({
    super.key,
    required this.clubName,
    required this.category,
    required this.memberCount,
    required this.isJoined,
    required this.icon,
    this.color = TColors.sunshade,
    this.showStatus = true,
  });

  final String clubName;
  final String category;
  final int memberCount;
  final bool isJoined;
  final IconData icon;
  final Color color;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Icon Box
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),

          // 2. Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clubName,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                     _buildTag(context, category, Colors.blue),
                     const SizedBox(width: 8),
                     Expanded(
                       child: Text(
                        "$memberCount ${TTexts.labelMember}",
                        style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                       ),
                     ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Status
          if (showStatus && isJoined)
             const Icon(Icons.check_circle, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall!.apply(color: color),
      ),
    );
  }
}
