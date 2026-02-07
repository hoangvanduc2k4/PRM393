import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.eventName,
    required this.date,
    required this.month,
    required this.time,
    required this.location,
    this.color = TColors.primary,
  });

  final String eventName;
  final String date;
  final String month;
  final String time;
  final String location;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
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
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Date Column
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: Theme.of(context).textTheme.headlineMedium!.apply(color: color, fontWeightDelta: 2),
                  ),
                  Text(
                    month,
                    style: Theme.of(context).textTheme.titleMedium!.apply(color: color),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Iconsax.clock, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Iconsax.location, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Arrow icon removed as per user request (Leaf node)
          ],
        ),
      ),
    );
  }
}
