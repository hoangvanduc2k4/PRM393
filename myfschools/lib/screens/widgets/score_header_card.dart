import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizes.dart';

class ScoreHeaderCard extends StatelessWidget {
  final StudentModel? student;

  const ScoreHeaderCard({Key? key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (student == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: 180, // Approximate height
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radius24),
        gradient: LinearGradient(
          colors: [
            Color(0xFFB0BEC5), // Light Gray
            Color(0xFF90A4AE), // Darker Gray
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background decoration (circles/curves) - Keeping it simple for now
          Positioned(
             right: -20,
             bottom: -20,
             child: Opacity(
               opacity: 0.1,
               child: CircleAvatar(radius: 80, backgroundColor: Colors.white),
             ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppSizes.p20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 30, // Slightly smaller than home
                    backgroundImage: NetworkImage(student!.avatarUrl),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        student!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student!.id,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Mascot Image (Placeholder)
          Positioned(
            right: 16,
            bottom: 16,
             child: Container(
               width: 100,
               height: 100,
               // Using a placeholder icon or image if available
               // In the design it's a bee/robot mascot sitting on books
               alignment: Alignment.center,
               child: Icon(Icons.school, size: 60, color: Colors.orange), 
             ),
          ),
        ],
      ),
    );
  }
}
