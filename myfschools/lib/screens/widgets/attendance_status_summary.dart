import 'package:flutter/material.dart';

class AttendanceStatusSummary extends StatelessWidget {
  const AttendanceStatusSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildStatusTag("Có mặt", 8, Colors.green),
          const SizedBox(width: 16),
          _buildStatusTag("Vắng mặt", 0, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String label, int count, Color color) {
    return Row(
      children: [
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(width: 8),
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
