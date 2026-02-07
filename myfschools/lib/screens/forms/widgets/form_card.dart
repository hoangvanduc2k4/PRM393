import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../common/styles/shadow_styles.dart';

class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    required this.title,
    required this.type,
    required this.date,
    required this.reason,
    required this.status,
  });

  final String title; // e.g. "Xin nghỉ học", "Xin đến muộn"
  final String type; // e.g. "Xin nghỉ học vì lý do sức khỏe", "Xin đến muộn tiết 1"
  final String date;
  final String reason;
  final String status;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;

    switch (status) {
      case TTexts.statusApproved:
        statusColor = Colors.green;
        statusBgColor = Colors.green.withOpacity(0.1);
        break;
      case TTexts.statusPending:
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withOpacity(0.1);
        break;
      case TTexts.statusRejected:
        statusColor = Colors.red;
        statusBgColor = Colors.red.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [TShadowStyle.softShadow],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Type Tag & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title, 
                  style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.deepOrange),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                 decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelMedium!.apply(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Title
          Text(
            type,
            style: Theme.of(context).textTheme.titleMedium!.apply(fontWeightDelta: 2),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.xs),

          // Date
          Text(
            "${TTexts.datePrefix}$date",
            style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.darkGrey),
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          
          // Reason
          Text(
            "${TTexts.reasonPrefix}$reason",
            style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.darkGrey),
             maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
