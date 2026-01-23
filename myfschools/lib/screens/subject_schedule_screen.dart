import 'package:flutter/material.dart';
import '../../models/timetable_model.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/helpers/date_formatting.dart';
import '../../common/widgets/empty_state.dart';

class SubjectScheduleScreen extends StatelessWidget {
  final String subjectCode;
  final List<TimetableModel> slots;

  const SubjectScheduleScreen({
    Key? key,
    required this.subjectCode,
    required this.slots,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$subjectCode - Schedule')),
      body: slots.isEmpty
          ? const EmptyState(message: 'No schedule available for this subject')
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.p16),
              itemCount: slots.length,
              itemBuilder: (ctx, index) {
                final slot = slots[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slot.subjectCode,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Room: ${slot.room} | Lect: ${slot.lecturer}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${DateFormatting.formatDayMonth(slot.startTime)} - ${DateFormatting.formatTime(slot.startTime)} - ${DateFormatting.formatTime(slot.endTime)}',
                                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
