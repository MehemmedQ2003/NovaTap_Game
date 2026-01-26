import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/services/score_service.dart';
import '../components/avatar_selector.dart';
import '../components/podium_widget.dart';

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Puan Tablosu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ScoreEntry>>(
        future: ScoreService().getHighScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final scores = snapshot.data!;
          if (scores.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.leaderboard_outlined,
                    size: 80,
                    color: AppColors.neutral.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Henuz kayitli skor yok",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.neutral,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Oyun oynayarak skor tablosuna gir!",
                    style: TextStyle(color: AppColors.neutral),
                  ),
                ],
              ),
            );
          }

          final topThree = scores.take(3).toList();
          final restOfScores = scores.length > 3 ? scores.sublist(3) : <ScoreEntry>[];

          return SingleChildScrollView(
            child: Column(
              children: [
                // Podium for top 3
                PodiumWidget(topThree: topThree),

                const Divider(height: 32),

                // Rest of the scores
                if (restOfScores.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Diger Skorlar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...restOfScores.asMap().entries.map((entry) {
                          final index = entry.key + 4; // Starting from 4th place
                          final scoreData = entry.value;
                          return _ScoreListItem(
                            rank: index,
                            entry: scoreData,
                          );
                        }),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ScoreListItem extends StatelessWidget {
  final int rank;
  final ScoreEntry entry;

  const _ScoreListItem({
    required this.rank,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$rank.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.neutral,
                ),
              ),
            ),
            AvatarWidget(
              avatarIndex: entry.avatarIndex,
              size: 40,
            ),
          ],
        ),
        title: Text(
          entry.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          entry.difficulty,
          style: const TextStyle(fontSize: 12, color: AppColors.neutral),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${entry.score} P',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.success,
            ),
          ),
        ),
      ),
    );
  }
}
