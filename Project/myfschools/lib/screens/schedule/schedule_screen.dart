import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/schedule_card.dart';
import '../../controllers/schedule_controller.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Center date (Hôm nay)
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _currentWeek = [];
  
  final ScheduleController _scheduleController = ScheduleController();

  @override
  void initState() {
    super.initState();
    _currentWeek = _generateWeekDays(_selectedDate);
    // Báo cho controller biết mình đang xem ngày bao nhiêu để nó lọc
    // Hàm này phải chờ widget render xong mới chạy để không tự chặn luồng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleController.filterByDate(_selectedDate);
    });
  }

  // Tạo 7 ngày (hôm nay +- 3 ngày)
  List<DateTime> _generateWeekDays(DateTime center) {
    List<DateTime> days = [];
    for (int i = -3; i <= 3; i++) {
      days.add(center.add(Duration(days: i)));
    }
    return days;
  }

  // Helper lấy tên Ngày
  String _getDayName(int weekday) {
    if (weekday == 7) return "CN";
    return "T${weekday + 1}";
  }

  // Format giờ học theo Slot
  String _getSlotTime(int slot) {
    switch(slot) {
      case 1: return "07:30 - 09:00";
      case 2: return "09:15 - 11:45";
      case 3: return "12:30 - 14:00";
      case 4: return "14:15 - 16:45";
      case 5: return "17:00 - 19:30";
      default: return "00:00 - 00:00";
    }
  }

  // Giả lập trạng thái điểm danh (tương lai là Upcoming, quá khứ là Attended/Absent)
  String _getFakeStatus(DateTime date, int slot) {
    DateTime now = DateTime.now();
    if (date.isAfter(now)) return TTexts.statusUpcoming;
    if (date.day == now.day && slot > 3) return TTexts.statusUpcoming;
    return TTexts.statusAttended;
  }

  @override
  Widget build(BuildContext context) {
    _currentWeek = _generateWeekDays(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.schedule, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: TColors.sunshade,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // -- Chọn Ngày
          Container(
            padding: const EdgeInsets.only(bottom: TSizes.md),
            color: Colors.white,
            child: SizedBox(
              height: 70,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                scrollDirection: Axis.horizontal,
                itemCount: _currentWeek.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final DateTime date = _currentWeek[index];
                  final bool isSelected = index == 3; // Luôn lấy thẻ giữa
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                      _scheduleController.filterByDate(date); // Báo controller lọc lại list
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: Theme.of(context).textTheme.titleSmall!.apply(
                                color: Colors.black,
                                fontWeightDelta: 1
                              ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                           width: 35,
                           height: 35,
                           alignment: Alignment.center,
                           decoration: BoxDecoration(
                             color: isSelected ? TColors.sunshade : Colors.transparent, // Background cam nếu chọn
                             shape: BoxShape.circle,
                           ),
                           child: Text(
                            "${date.day}",
                            style: Theme.of(context).textTheme.titleMedium!.apply(
                                  color: isSelected ? Colors.white : Colors.black, // Màu chữ
                                  fontWeightDelta: 2,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: TSizes.spaceBtwSections),

          // -- Danh sách môn học (Dùng Firebase Data)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: AnimatedBuilder(
                animation: _scheduleController,
                builder: (context, _) {
                  if (_scheduleController.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: TColors.sunshade));
                  }

                  if (_scheduleController.dailySchedules.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Column(
                          children: [
                            const Icon(Iconsax.calendar_remove, size: 60, color: TColors.grey),
                            const SizedBox(height: TSizes.sm),
                            Text("Không có lịch học hôm nay", style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _scheduleController.dailySchedules.length,
                    itemBuilder: (context, index) {
                      final item = _scheduleController.dailySchedules[index];
                      return ScheduleCard(
                        subjectName: item.subject,
                        room: item.room,
                        time: _getSlotTime(item.slot),
                        teacher: item.teacher,
                        status: _getFakeStatus(_selectedDate, item.slot),
                      );
                    },
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
