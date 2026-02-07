import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class ClubCard extends StatelessWidget {
  const ClubCard({
    super.key,
    required this.clubName,
    required this.category,
    required this.memberCount,
    required this.isJoined,
    required this.icon,
    this.color = TColors.primary,
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
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwSections),
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // -- Cover Image & Logo Overlap
          SizedBox(
            height: 100, // Cover height + half logo overlap
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // Cover Image (Top half)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 70,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2), // Light version of club color
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                ),
                // Logo (Circular)
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),

          // -- Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
            child: Column(
              children: [
                // Name
                Text(
                  clubName,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Category & Members
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTag(context, category, Colors.blue),
                    const SizedBox(width: 8),
                    _buildTag(context, "$memberCount thành viên", Colors.grey),
                  ],
                ),
                const SizedBox(height: TSizes.md),

                // Status (Read-only)
                if (showStatus && isJoined)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            "Đã tham gia",
                            style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (showStatus) // Only add spacing if we *were* considering showing status but didn't (not joined) or just spacing
                   const SizedBox(height: 10)
                else 
                   const SizedBox.shrink(), // No status, no extra space needed (or minimal)
                
                const SizedBox(height: 4),
              ],
            ),
          ),
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
