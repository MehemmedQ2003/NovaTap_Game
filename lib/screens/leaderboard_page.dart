import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../utils/time_formatter.dart';

class LeaderboardPage extends StatelessWidget {
  final List<ScoreRecord> history;

  const LeaderboardPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final sorted = List<ScoreRecord>.from(history)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoreboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: sorted.isEmpty
            ? const Center(
                child: Text('Play a round to see scores here.', style: TextStyle(color: Colors.white70)))
            : ListView.separated(
                itemCount: sorted.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                itemBuilder: (context, index) {
                  final entry = sorted[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${entry.score} pts', style: const TextStyle(fontSize: 20)),
                    subtitle: Text('${entry.levelName} • ${formatTime(entry.recordedAt)}',
                        style: const TextStyle(color: Colors.white54)),
                    trailing: Text('#${index + 1}',
                        style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  );
                },
              ),
      ),
    );
  }
}
