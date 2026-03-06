import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.time,
    required this.date,
  });

  final String title;
  final String content;
  final String time;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết thông báo", style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFA726),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall!.apply(fontWeightDelta: 2, color: Colors.black87),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Date & Time
              Row(
                children: [
                   const Icon(Iconsax.clock, size: 16, color: Colors.grey),
                   const SizedBox(width: 4),
                   Text(
                     "$time - $date",
                     style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.grey),
                   ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Content
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge!.apply(heightFactor: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
