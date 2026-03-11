import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class GradeCard extends StatelessWidget {
  const GradeCard({
    super.key,
    required this.subjectName,
    required this.subjectCode,
    this.quiz15Min,
    this.oralTest,
    this.test45Min,
    this.finalExam,
  });

  final String subjectName;
  final String subjectCode;
  final double? quiz15Min;
  final double? oralTest;
  final double? test45Min;
  final double? finalExam;

  double get averageScore {
    int count = 0;
    double sum = 0;
    if (quiz15Min != null) { sum += quiz15Min!; count++; }
    if (oralTest != null) { sum += oralTest!; count++; }
    if (test45Min != null) { sum += test45Min! * 2; count += 2; }
    if (finalExam != null) { sum += finalExam! * 3; count += 3; }
    return count > 0 ? (sum / count) : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TColors.sunshade.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  subjectName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9), // Light Green bg
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: const Text(
                  TTexts.scoreEntering,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32), // Dark Green text
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          
          // Scores
          _buildScoreRow("Điểm miệng", oralTest?.toString() ?? "-"),
          const SizedBox(height: 12),
          _buildScoreRow("Điểm 15 phút", quiz15Min?.toString() ?? "-"),
          const SizedBox(height: 12),
          _buildScoreRow("Điểm 1 tiết", test45Min?.toString() ?? "-"),
          const SizedBox(height: 12),
          _buildScoreRow("Điểm thi học kỳ", finalExam?.toString() ?? "-"),
          const SizedBox(height: 16),
          const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          _buildScoreRow(TTexts.scoreTotal, averageScore.toStringAsFixed(2), isTotal: true),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, String score, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: const Color(0xFF757575), // Grey text
          ),
        ),
        Text(
          score,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: TColors.sunshade, // Orange text for score
          ),
        ),
      ],
    );
  }
}
