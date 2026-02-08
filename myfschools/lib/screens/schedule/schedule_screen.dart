import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/schedule_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Center date (initially today or specific mock date)
  DateTime _selectedDate = DateTime(2026, 1, 29); // Mocking "Wednesday 29" as start

  List<DateTime> _currentWeek = [];

  @override
  void initState() {
    super.initState();
    _currentWeek = _generateWeekDays(_selectedDate);
  }

  // Generate 7 days: [center-3, ..., center, ..., center+3]
  List<DateTime> _generateWeekDays(DateTime center) {
    List<DateTime> days = [];
    for (int i = -3; i <= 3; i++) {
      days.add(center.add(Duration(days: i)));
    }
    return days;
  }

  // Helper to get Day Name (T2, T3...)
  String _getDayName(int weekday) {
    if (weekday == 7) return "CN";
    return "T${weekday + 1}";
  }

  @override
  Widget build(BuildContext context) {
    // Regenerate week based on selected date to keep it centered
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
          // -- Date Selector
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
                  final bool isSelected = index == 3; // Center item is always selected
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: Theme.of(context).textTheme.titleSmall!.apply(
                                color: Colors.black, // Grey text for Day
                                fontWeightDelta: 1
                              ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                           width: 35,
                           height: 35,
                           alignment: Alignment.center,
                           decoration: BoxDecoration(
                             color: isSelected ? TColors.sunshade : Colors.transparent, // Orange circle
                             shape: BoxShape.circle,
                           ),
                           child: Text(
                            "${date.day}",
                            style: Theme.of(context).textTheme.titleMedium!.apply(
                                  color: isSelected ? Colors.white : Colors.black, // White or Blue text
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

          // -- Schedule List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: ListView(
                children: [
                  // Section Title (Current Date) - Removed as per new design
                  // Text(
                  //   "Thứ ${_dates[_selectedIndex]["day"]!.replaceAll("T", "")}, ngày ${_dates[_selectedIndex]["date"]}/01", 
                  //   style: Theme.of(context).textTheme.titleLarge
                  // ),
                  const SizedBox(height: TSizes.md),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Mock classes (Change based on selection for demo purposes)
                  // Mock classes logic
                  // Monday 27th Jan 2026
                  if (_selectedDate.year == 2026 && _selectedDate.month == 1 && _selectedDate.day == 27) ...[
                     const ScheduleCard(
                      subjectName: "Lập trình di động (PRM393)",
                      room: "P.302",
                      time: "07:30 - 09:00",
                      teacher: "GV. Nguyễn Văn A",
                      status: TTexts.statusAttended,
                    ),
                    const ScheduleCard(
                      subjectName: "Kiến trúc phần mềm (SWT301)",
                      room: "P.405",
                      time: "09:15 - 11:45",
                      teacher: "GV. Trần Thị B",
                      status: TTexts.statusAttended,
                    ),
                  // Wednesday 29th Jan 2026 (Mock "Today")
                  ] else if (_selectedDate.year == 2026 && _selectedDate.month == 1 && _selectedDate.day == 29) ...[
                     const ScheduleCard(
                      subjectName: "Tiếng Anh chuyên ngành",
                      room: "P.201",
                      time: "13:30 - 15:00",
                      teacher: "GV. Leanne",
                      status: TTexts.statusUpcoming,
                    ),
                  ] else ...[
                     Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Column(
                          children: [
                            const Icon(Iconsax.calendar_remove, size: 60, color: TColors.grey),
                            const SizedBox(height: TSizes.sm),
                            Text("Không có lịch học", style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
