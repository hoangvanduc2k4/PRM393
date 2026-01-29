import 'package:flutter/material.dart';
import '../../controllers/attendance_controller.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_sizes.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';
import '../../common/widgets/date_selector.dart';
import 'widgets/attendance_status_summary.dart';
import 'widgets/attendance_timeline_item.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController _controller = AttendanceController();
  DateTime _selectedDate = DateTime.now(); // Default to today OR specific date if needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Điểm danh"),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Date String
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 16),
             alignment: Alignment.centerLeft,
             child: Text(
               "Thứ ${_selectedDate.weekday + 1}, ngày ${_selectedDate.day} tháng ${_selectedDate.month} năm ${_selectedDate.year}",
               style: const TextStyle(color: Colors.black87, fontSize: 14),
             ),
          ),
          
          // Date Selector
          DateSelector(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                // Ideally reload controller data here if it wasn't mock
                // _controller.loadAttendanceForDate(date);
              });
            },
          ),
          
          // Status Summary
          const AttendanceStatusSummary(),
          const SizedBox(height: 8),

          // Timeline List
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (_controller.isLoading) {
                  return const LoadingIndicator();
                }
                
                // For mock consistency, if date is NOT the mock date, maybe show empty?
                // Mock data is static properly, let's filter just to demonstrate logic if model supported date
                // Current AttendanceTimelineModel doesn't strictly have date, let's assume all mock data is for "Today"
                // or just show it regardless for layout check.
                
                if (_controller.timelineList.isEmpty) {
                  return const EmptyState(message: 'No classes for this day');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  itemCount: _controller.timelineList.length,
                  itemBuilder: (ctx, index) {
                    final item = _controller.timelineList[index];
                    return Column(
                      children: [
                        if (index == 0 || _controller.timelineList[index-1].startTime != item.startTime)
                            const SizedBox(),
                        AttendanceTimelineItem(item: item),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
