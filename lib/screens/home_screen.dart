import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../widgets/stat_card.dart';
import '../widgets/leaderboard_snippet.dart';

class HomeScreen extends StatelessWidget {
  final int bestScore;
  final List<ScoreRecord> history;
  final ThemeMode themeMode;
  final VoidCallback onCycleTheme;
  final void Function(BuildContext) onStartGame;
  final void Function(BuildContext) onShowLeaderboard;
  final void Function(BuildContext) onShowModeGallery;
  final void Function(BuildContext) onShowStats;

  const HomeScreen({
    super.key,
    required this.bestScore,
    required this.history,
    required this.themeMode,
    required this.onCycleTheme,
    required this.onStartGame,
    required this.onShowLeaderboard,
    required this.onShowModeGallery,
    required this.onShowStats,
  });

  @override
  Widget build(BuildContext context) {
    final recent = history.take(3).toList();
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Nova Tap',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            )),
                  ),
                  IconButton(
                    onPressed: onCycleTheme,
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    tooltip: 'Toggle theme',
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Reflex sprint - multi-page rhythm - leaderboard ready',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(label: 'Best Score', value: bestScore),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(label: 'Sessions', value: history.length),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Build a streak in the game page, then inspect the leaderboard to see the freshest runs.',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => onStartGame(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Start Sprint', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => onShowModeGallery(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Explore Modes', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => onShowLeaderboard(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('View Scoreboard', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => onShowStats(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Stats & Trends', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              if (recent.isNotEmpty) LeaderboardSnippet(recent: recent),
            ],
          ),
        ),
      ),
    );
  }
}
