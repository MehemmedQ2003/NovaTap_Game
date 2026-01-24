import 'dart:math';

import 'package:flutter/material.dart';

import 'models/word_level.dart';
import 'models/score_record.dart';
import 'screens/game_page.dart';
import 'screens/home_screen.dart';
import 'screens/leaderboard_page.dart';
import 'screens/mode_gallery.dart';
import 'screens/stats_page.dart';

void main() {
  runApp(const NovaTapApp());
}

class NovaTapApp extends StatefulWidget {
  const NovaTapApp({super.key});

  @override
  State<NovaTapApp> createState() => _NovaTapAppState();
}

class _NovaTapAppState extends State<NovaTapApp> {
  final List<ScoreRecord> _history = [];
  ThemeMode _themeMode = ThemeMode.system;

  int get bestScore =>
      _history.isEmpty ? 0 : _history.map((entry) => entry.score).reduce(max);

  void _registerScore(ScoreRecord record) {
    setState(() {
      _history.insert(0, record);
      if (_history.length > 10) {
        _history.removeRange(10, _history.length);
      }
    });
  }

  void _pushGame(BuildContext context, [WordLevel level = WordLevel.easy]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NovaTapGamePage(
          baselineBest: bestScore,
          onRoundComplete: _registerScore,
          level: level,
        ),
      ),
    );
  }

  void _pushLeaderboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LeaderboardPage(history: List.unmodifiable(_history)),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _pushModeGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (builderCtx) => ModeGalleryPage(onSelectMode: (level) {
          Navigator.of(builderCtx).pop();
          _pushGame(context, level);
        }),
      ),
    );
  }

  void _pushStats(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StatsPage(history: List.unmodifiable(_history)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova Tap',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF050A1B),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        bestScore: bestScore,
        history: List.unmodifiable(_history),
        themeMode: _themeMode,
        onCycleTheme: _toggleTheme,
        onStartGame: _pushGame,
        onShowLeaderboard: _pushLeaderboard,
        onShowModeGallery: _pushModeGallery,
        onShowStats: _pushStats,
      ),
      themeMode: _themeMode,
    );
  }
}
