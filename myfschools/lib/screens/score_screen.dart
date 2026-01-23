import 'package:flutter/material.dart';
import '../../controllers/score_controller.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_sizes.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';

class ScoreScreen extends StatelessWidget {
  ScoreScreen({Key? key}) : super(key: key);

  final ScoreController _controller = ScoreController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.scores)),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const LoadingIndicator();
          }
          if (_controller.scores.isEmpty) {
            return const EmptyState(message: 'No scores available');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.p16),
            itemCount: _controller.scores.length,
            itemBuilder: (ctx, index) {
              final score = _controller.scores[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            score.subjectCode,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            score.status,
                            style: TextStyle(
                              color: score.status == 'Passed' ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        score.subjectName,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildScoreItem('Mid-term', score.midTerm),
                          _buildScoreItem('Process', score.process),
                          _buildScoreItem('Final', score.finalTerm),
                          _buildScoreItem('Total', score.total, isBold: true),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScoreItem(String label, double score, {bool isBold = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
