import 'package:flutter/material.dart';
import '../../models/score_model.dart';
import '../../utils/constants/app_sizes.dart';

class ExpandableSubjectScore extends StatelessWidget {
  final ScoreModel score;

  const ExpandableSubjectScore({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(), // Remove default border
          title: Text(
            score.subjectName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: null,
          trailing: Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
             decoration: BoxDecoration(
               color: Colors.green.withOpacity(0.1),
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: Colors.green.withOpacity(0.3)),
             ),
             child: const Text(
               "• Đang nhập điểm",
               style: TextStyle(
                 fontSize: 12,
                 color: Colors.green,
                 fontWeight: FontWeight.bold,
               ),
             ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            _buildScoreRow("Đánh giá thường xuyên 1", score.midTerm), 
            // Mapping existing model fields to the design's fields
            // Design has: DG Thuong xuyen 1, DG Giua ky
            _buildScoreRow("Đánh giá giữa kỳ", score.process),
            _buildScoreRow("Đánh giá cuối kỳ", score.finalTerm), // Added logic
            const Divider(),
             _buildScoreRow("Tổng kết", score.total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, double val, {bool isTotal = false}) {
    // Determine color based on value (mock logic)
    Color scoreColor = Colors.orange;
    if (val >= 9) scoreColor = Colors.orange; // High score
    else if (val >= 5) scoreColor = Colors.orange; // Average
    else scoreColor = Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            val.toString(),
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
