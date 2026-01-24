import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../utils/time_formatter.dart';

class StatsPage extends StatelessWidget {
  final List<ScoreRecord> history;

  const StatsPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final totalSessions = history.length;
    final totalScore = history.fold<int>(0, (sum, entry) => sum + entry.score);
    final average = totalSessions == 0 ? '0' : (totalScore / totalSessions).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Stats'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _StatTile(label: 'Sessions', value: totalSessions.toString()),
                const SizedBox(width: 12),
                _StatTile(label: 'Avg Score', value: average),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Recent results', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: history.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.white24),
                itemBuilder: (context, index) {
                  final entry = history[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${entry.score} pts'),
                    subtitle: Text('${entry.levelName} • ${formatTime(entry.recordedAt)}',
                        style: const TextStyle(color: Colors.white54)),
                    trailing:
                        Text('#${index + 1}', style: const TextStyle(color: Colors.white70)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white24, Colors.white10],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
