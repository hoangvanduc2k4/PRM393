import 'package:flutter/material.dart';
import '../../models/timetable_model.dart';
import '../../utils/helpers/date_formatting.dart';

class TimetableItem extends StatelessWidget {
  final TimetableModel item;

  const TimetableItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine status (ongoing, upcoming, finished)
    final now = DateTime.now();
    Color statusColor = Colors.grey;
    String statusText = "Upcoming";
    
    if (now.isAfter(item.startTime) && now.isBefore(item.endTime)) {
      statusColor = Colors.green;
      statusText = "Ongoing";
    } else if (now.isAfter(item.endTime)) {
       statusColor = Colors.blueGrey;
       statusText = "Finished";
    }

    // Format times
    final startStr = "${item.startTime.hour.toString().padLeft(2, '0')}:${item.startTime.minute.toString().padLeft(2, '0')}";
    final endStr = "${item.endTime.hour.toString().padLeft(2, '0')}:${item.endTime.minute.toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(color: statusColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.subjectCode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "$startStr - $endStr",
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.room, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Room ${item.room}",
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Lecturer: ${item.lecturer}",
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
