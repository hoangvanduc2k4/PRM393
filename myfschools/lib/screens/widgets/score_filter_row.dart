import 'package:flutter/material.dart';
import '../../utils/constants/app_sizes.dart';

class ScoreFilterRow extends StatelessWidget {
  const ScoreFilterRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Filter Icon Button
             Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                 color: Colors.white,
                 shape: BoxShape.circle,
                 boxShadow: [
                   BoxShadow(color: Colors.black12, blurRadius: 4),
                 ]
               ),
               child: const Icon(Icons.filter_list, size: 20),
             ),
             const SizedBox(width: 12),
             
             // Year Button
             _buildFilterChip("2025-2026"),
             const SizedBox(width: 8),
             
             // Semester Button
             _buildFilterChip("Kỳ 1"),
             const SizedBox(width: 8),
             
             // Type Button
             _buildFilterChip("Chính khoá"),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E6), // Light orange background for active/default
        // Or Colors.white if not active
        border: Border.all(color: Colors.orangeAccent),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: Colors.deepOrange, size: 20),
        ],
      ),
    );
  }
}
