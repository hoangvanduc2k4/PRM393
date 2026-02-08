import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sự kiện", style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: TColors.sunshade, // Light Orange to match theme
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView(
          children: const [
            EventCard(
              eventName: "Họp phụ huynh đầu năm",
              date: "15",
              month: "TH08",
              time: "08:00 - 11:00",
              location: "P.201 - Tòa nhà Gamma",
              color: Colors.orange,
            ),
            EventCard(
              eventName: "Lễ Khai Giảng Năm Học 2025-2026",
              date: "05",
              month: "TH09",
              time: "07:30 - 10:00",
              location: "Sân trường FPT School",
              color: Colors.red,
            ),
            EventCard(
              eventName: "Hội thao F-Sports",
              date: "20",
              month: "TH10",
              time: "08:00 - 17:00",
              location: "Sân vận động",
              color: Colors.blue,
            ),
            EventCard(
              eventName: "Ngày hội đọc sách",
              date: "12",
              month: "TH11",
              time: "09:00 - 16:00",
              location: "Thư viện trường",
              color: Colors.green,
            ),
            EventCard(
              eventName: "Lễ hội Xuân Quê Hương",
              date: "25",
              month: "TH01",
              time: "18:00 - 21:00",
              location: "Hội trường Beta",
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
