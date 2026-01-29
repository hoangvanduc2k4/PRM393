import 'package:flutter/material.dart';
import '../../controllers/timetable_controller.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_sizes.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';
import '../../common/widgets/date_selector.dart';
import 'widgets/timetable_item.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final TimetableController _controller = TimetableController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Thời khoá biểu"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
           // Date Selector (Centered logic handled by widget)
           DateSelector(
             selectedDate: _selectedDate,
             onDateSelected: (date) {
               setState(() {
                 _selectedDate = date;
               });
             },
           ),
           
           Expanded(
             child: AnimatedBuilder(
               animation: _controller,
               builder: (context, child) {
                 if (_controller.isLoading) {
                   return const LoadingIndicator();
                 }
                 
                 // Get slots for selected date
                 final slots = _controller.getSlotsForDay(_selectedDate);
                 
                 if (slots.isEmpty) {
                   return const EmptyState(message: 'No classes today');
                 }
                 
                 return ListView.builder(
                   padding: const EdgeInsets.all(AppSizes.p16),
                   itemCount: slots.length,
                   itemBuilder: (context, index) {
                     return TimetableItem(item: slots[index]);
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
