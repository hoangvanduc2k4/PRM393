import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/grade_card.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.grades, style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFA726), // Orange
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView(
          children: [
            // -- Dropdowns
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: "2024-2025",
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: "2024-2025", child: Text("2024-2025")),
                          DropdownMenuItem(value: "2023-2024", child: Text("2023-2024")),
                        ],
                        onChanged: (val) {},
                      ),
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
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: "Học kỳ 1",
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: "Học kỳ 1", child: Text("Học kỳ 1")),
                          DropdownMenuItem(value: "Học kỳ 2", child: Text("Học kỳ 2")),
                        ],
                        onChanged: (val) {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // -- Section Title
            const Text(
              "Kết quả Học kỳ 1 - Năm học 2024-2025",
              style: TextStyle(
                color: Color(0xFFFF5722), // Orange color
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // -- Grade List
            const GradeCard(
              subjectName: "Mobile Programming",
              subjectCode: "PRM393",
              averageScore: 8.9,
              status: "Passed",
            ),
             const GradeCard(
              subjectName: "Software Project",
              subjectCode: "SWP391",
              averageScore: 0.0,
              status: "NotYet",
            ),
             const GradeCard(
              subjectName: "Software Testing",
              subjectCode: "SWT301",
              averageScore: 8.5,
              status: "Passed",
            ),
          ],
        ),
      ),
    );
  }
}
