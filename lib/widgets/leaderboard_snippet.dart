import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../utils/time_formatter.dart';

class LeaderboardSnippet extends StatelessWidget {
  final List<ScoreRecord> recent;

  const LeaderboardSnippet({super.key, required this.recent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Latest sprints', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        ...recent.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('- ${entry.score} pts • ${entry.levelName} • ${formatTime(entry.recordedAt)}',
                  style: const TextStyle(color: Colors.white54)),
            )),
      ],
    );
  }
}
