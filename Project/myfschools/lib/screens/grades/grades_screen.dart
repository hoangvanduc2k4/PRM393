import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/grade_card.dart';
import '../../controllers/grade_controller.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final GradeController _gradeController = GradeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.grades, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: TColors.sunshade, // Orange
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            // -- Dropdowns (Lọc Học Kỳ)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AnimatedBuilder(
                      animation: _gradeController,
                      builder: (context, _) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _gradeController.selectedYear,
                            isExpanded: true,
                            items: const <DropdownMenuItem<String>>[
                              DropdownMenuItem(value: "2025-2026", child: Text("2025-2026")),
                              DropdownMenuItem(value: "2024-2025", child: Text("2024-2025")),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _gradeController.setYear(val);
                              }
                            },
                          ),
                        );
                      }
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AnimatedBuilder(
                      animation: _gradeController,
                      builder: (context, _) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _gradeController.selectedTerm,
                            isExpanded: true,
                            items: const <DropdownMenuItem<String>>[
                              DropdownMenuItem(value: "Học kỳ 1", child: Text("Học kỳ 1")),
                              DropdownMenuItem(value: "Học kỳ 2", child: Text("Học kỳ 2")),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _gradeController.setTerm(val);
                              }
                            },
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // -- Section Title
            AnimatedBuilder(
              animation: _gradeController,
              builder: (context, _) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Kết quả ${_gradeController.selectedTerm} - Năm học ${_gradeController.selectedYear}",
                    style: const TextStyle(
                      color: TColors.sunshade, // Orange color
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              }
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // -- Grade List
            Expanded(
              child: AnimatedBuilder(
                animation: _gradeController,
                builder: (context, _) {
                  if (_gradeController.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: TColors.sunshade));
                  }

                  if (_gradeController.filteredGrades.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.task_square, size: 60, color: TColors.grey),
                          const SizedBox(height: TSizes.sm),
                          Text("Chưa có điểm học kỳ này", style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _gradeController.filteredGrades.length,
                    itemBuilder: (context, index) {
                      final grade = _gradeController.filteredGrades[index];

                      return GradeCard(
                        subjectName: grade.subject,
                        subjectCode: "...", // DB hiện chưa có mã môn
                        quiz15Min: grade.quiz15Min,
                        oralTest: grade.oralTest,
                        test45Min: grade.test45Min,
                        finalExam: grade.finalExam,
                      );
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
