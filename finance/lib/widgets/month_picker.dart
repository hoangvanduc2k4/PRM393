import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const MonthPicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            onPressed: () {
              onDateChanged(DateTime(selectedDate.year, selectedDate.month - 1));
            },
          ),
          const SizedBox(width: 8),
          Text(
            'Tháng ${selectedDate.month}/${selectedDate.year}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
           IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              onDateChanged(DateTime(selectedDate.year, selectedDate.month + 1));
            },
          ),
        ],
      ),
    );
  }
}
