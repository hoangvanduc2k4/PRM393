import 'package:flutter/material.dart';
import '../../controllers/attendance_controller.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_sizes.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({Key? key}) : super(key: key);

  final AttendanceController _controller = AttendanceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.attendance)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const LoadingIndicator();
          }
          if (_controller.attendanceList.isEmpty) {
            return const EmptyState(message: 'No attendance data');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.p16),
            itemCount: _controller.attendanceList.length,
            itemBuilder: (ctx, index) {
              final item = _controller.attendanceList[index];
              final isWarning = item.absentPercentage >= 10.0;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.course,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isWarning ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${item.absentPercentage}%',
                              style: TextStyle(
                                color: isWarning ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.block, size: 16, color: Colors.redAccent),
                          const SizedBox(width: 8),
                          Text('Vắng: ${item.absent} / ${item.totalSlots} slots'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: item.absentPercentage / 20.0, // Scale for visual (e.g. 20% limit)
                        backgroundColor: Colors.grey[200],
                        color: isWarning ? Colors.red : Colors.blue,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
