import 'package:flutter/material.dart';
import '../../utils/constants/app_colors.dart';

class CalendarStrip extends StatelessWidget {
  const CalendarStrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
    final dates = [12, 13, 14, 15, 16, 17, 18];
    final selectedIndex = 1; // "13" is selected in design

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(days.length, (index) {
          final isSelected = index == selectedIndex;
          return Column(
            children: [
              Text(
                days[index],
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.grey,
                  fontWeight: FontWeight.bold,
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
                  dates[index].toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Indicator dot logic if needed, design shows a line/dot below selected
               if (isSelected)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle
                    ),
                  )
            ],
          );
        }),
      ),
    );
  }
}
