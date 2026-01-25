import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/services/score_service.dart';

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Puan Tablosu")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ScoreService().getHighScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final scores = snapshot.data!;
          if (scores.isEmpty) {
            return const Center(child: Text("Henüz kayıtlı skor yok."));
          }

          return ListView.builder(
            itemCount: scores.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final scoreData = scores[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: index < 3
                        ? AppColors.accent
                        : AppColors.primary,
                    foregroundColor: index < 3
                        ? AppColors.textDark
                        : Colors.white,
                    child: Text("${index + 1}"),
                  ),
                  title: Text(
                    scoreData['name'],
                    style: AppTextStyles.subHeading,
                  ),
                  trailing: Text(
                    "${scoreData['score']} P",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.success,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
