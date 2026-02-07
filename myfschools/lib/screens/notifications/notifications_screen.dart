import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.notifications, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFA726), // Light Orange
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
            NotificationCard(
              title: "Nhắc nhở học phí",
              content: "Quý phụ huynh vui lòng hoàn thành đóng học phí Học kỳ 2 trước ngày 15/02/2026. Chi tiết xem tại mục Học phí.",
              time: "09:00",
              date: "07/02/2026",
              isImportant: true,
            ),
            NotificationCard(
              title: "Thông báo nghỉ Tết",
              content: "Nhà trường thông báo lịch nghỉ Tết Nguyên Đán từ ngày 14/02 đến hết ngày 28/02. Chúc quý phụ huynh và các em học sinh một năm mới An Khang Thịnh Vượng!",
              time: "14:30",
              date: "05/02/2026",
            ),
            NotificationCard(
              title: "Thay đổi thời khóa biểu",
              content: "Lớp 3A sẽ có sự thay đổi giáo viên môn Tiếng Anh từ tuần sau. Cô Lan sẽ thay thế thầy Hùng đứng lớp.",
              time: "08:15",
              date: "01/02/2026",
            ),
            NotificationCard(
              title: "Kết quả thi Học kỳ 1",
              content: "Đã có kết quả thi Học kỳ 1. Phụ huynh vui lòng truy cập mục Kết quả học tập để xem chi tiết điểm số của con em mình.",
              time: "10:00",
              date: "25/01/2026",
            ),
          ],
        ),
      ),
    );
  }
}
