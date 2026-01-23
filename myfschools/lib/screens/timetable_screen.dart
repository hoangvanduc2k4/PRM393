import 'package:flutter/material.dart';
import '../../controllers/timetable_controller.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_sizes.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';
import 'subject_schedule_screen.dart';

class TimetableScreen extends StatelessWidget {
  TimetableScreen({Key? key}) : super(key: key);

  final TimetableController _controller = TimetableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.timetable)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const LoadingIndicator();
          }
          final subjects = _controller.getSubjects();
          
          if (subjects.isEmpty) {
            return const EmptyState(message: 'No subjects in schedule');
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.p16),
            itemCount: subjects.length,
            itemBuilder: (ctx, index) {
              final subject = subjects[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.class_, color: Colors.white),
                  ),
                  title: Text(
                    subject,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    final slots = _controller.getSlotsForSubject(subject);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubjectScheduleScreen(
                          subjectCode: subject,
                          slots: slots,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
