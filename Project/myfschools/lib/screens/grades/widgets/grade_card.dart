import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class GradeCard extends StatelessWidget {
  const GradeCard({
    super.key,
    required this.subjectName,
    required this.subjectCode,
    required this.averageScore,
    required this.status, // "Passed", "Failed", "NotYet"
  });

  final String subjectName;
  final String subjectCode;
  final double averageScore;
  final String status;

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
          _buildScoreRow(TTexts.scoreComponent1, "8.5"),
          const SizedBox(height: 12),
          _buildScoreRow(TTexts.scoreMidterm, "9"),
          const SizedBox(height: 12),
          _buildScoreRow(TTexts.scoreFinal, "9"),
          const SizedBox(height: 16),
          const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          _buildScoreRow(TTexts.scoreTotal, averageScore.toString(), isTotal: true),
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
