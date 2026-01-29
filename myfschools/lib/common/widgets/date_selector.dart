import 'package:flutter/material.dart';
import '../../utils/constants/app_colors.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate dates: selected - 3 ... selected ... selected + 3 (Total 7)
    final dates = List.generate(7, (index) {
      return selectedDate.add(Duration(days: index - 3));
    });

    final days = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dates.map((date) {
           final isSelected = _isSameDay(date, selectedDate);
           final dayLabel = days[date.weekday == 7 ? 0 : date.weekday - 1]; // weekday 1=Mon(T2), 7=Sun(CN) -> index 0=CN if mapped to logic or standard

           // Logic: weekday 1 (Mon) -> T2 .. 7 (Sun) -> CN
           String weekdayStr;
           if (date.weekday == 7) {
             weekdayStr = "CN";
           } else {
             weekdayStr = "T${date.weekday + 1}";
           }

           return GestureDetector(
             onTap: () => onDateSelected(date),
             child: Column(
               children: [
                 Text(
                   weekdayStr,
                   style: TextStyle(
                     color: isSelected ? AppColors.primary : Colors.grey,
                     fontWeight: FontWeight.bold,
                     fontSize: 14,
                   ),
                 ),
                 const SizedBox(height: 8),
                 Container(
                   width: 36,
                   height: 36,
                   alignment: Alignment.center,
                   decoration: BoxDecoration(
                     color: isSelected ? AppColors.primary : Colors.transparent,
                     shape: BoxShape.circle,
                   ),
                   child: Text(
                     date.day.toString(),
                     style: TextStyle(
                       color: isSelected ? Colors.white : Colors.black87,
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                       fontSize: 16,
                     ),
                   ),
                 ),
                 const SizedBox(height: 4),
                 if (isSelected)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle
                      ),
                    )
                  else 
                    const SizedBox(height: 4), // Placeholder to keep alignment
               ],
             ),
           );
        }).toList(),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
