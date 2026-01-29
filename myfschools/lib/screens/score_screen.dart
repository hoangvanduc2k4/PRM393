import 'package:flutter/material.dart';
import '../../controllers/score_controller.dart';
import '../../models/student_model.dart';
import '../../utils/constants/app_sizes.dart';
import '../../utils/constants/app_colors.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';
import 'widgets/expandable_subject_score.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final ScoreController _controller = ScoreController();
  final StudentModel _student = StudentModel.getMockData();
  
  // State for filters
  String _selectedYear = '2024-2025';
  String _selectedSemester = 'Học kỳ 1';

  final List<String> _years = ['2024-2025', '2023-2024', '2022-2023'];
  final List<String> _semesters = ['Học kỳ 1', 'Học kỳ 2', 'Học kỳ Summer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Bảng điểm"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Info (Kept Simple)
          Container(
            padding: const EdgeInsets.all(AppSizes.p16),
            color: Colors.grey[50], 
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(_student.avatarUrl),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _student.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "MSSV: ${_student.id}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // FILTERS ROW (Year & Semester)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            child: Row(
              children: [
                // Year Dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedYear,
                        isExpanded: true,
                        items: _years.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedYear = newValue!;
                            // Trigger load data logic if needed
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Semester Dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSemester,
                        isExpanded: true,
                        items: _semesters.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSemester = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          
          // Current Selection Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            child: Text(
              "Kết quả $_selectedSemester - Năm học $_selectedYear", 
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          
           const SizedBox(height: 8),

          // List
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (_controller.isLoading) {
                  return const LoadingIndicator();
                }
                
                // Mock logic: Empty if Year 2022-2023 for demo, else show list
                if (_selectedYear == '2022-2023') {
                   return const EmptyState(message: 'Không tìm thấy dữ liệu năm học này');
                }

                if (_controller.scores.isEmpty) {
                  return const EmptyState(message: 'Chưa có bảng điểm');
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: AppSizes.p16),
                  itemCount: _controller.scores.length,
                  itemBuilder: (ctx, index) {
                    final score = _controller.scores[index];
                    return ExpandableSubjectScore(score: score);
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
