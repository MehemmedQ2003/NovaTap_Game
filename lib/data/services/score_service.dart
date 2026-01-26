import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreEntry {
  final String name;
  final int score;
  final int avatarIndex;
  final String difficulty;
  final DateTime date;

  ScoreEntry({
    required this.name,
    required this.score,
    required this.avatarIndex,
    required this.difficulty,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'score': score,
    'avatarIndex': avatarIndex,
    'difficulty': difficulty,
    'date': date.toIso8601String(),
  };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
    name: json['name'] as String,
    score: json['score'] as int,
    avatarIndex: json['avatarIndex'] as int? ?? 0,
    difficulty: json['difficulty'] as String? ?? 'Normal',
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
  );
}

class ScoreService {
  static const String _highScoreKey = 'high_scores_v3';

  Future<void> saveScore({
    required int score,
    required String playerName,
    required String difficultyName,
    required int avatarIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = prefs.getStringList(_highScoreKey) ?? [];

    final entry = ScoreEntry(
      name: playerName,
      score: score,
      avatarIndex: avatarIndex,
      difficulty: difficultyName,
      date: DateTime.now(),
    );

    scoresJson.add(jsonEncode(entry.toJson()));

    // Parse all scores
    final allScores = scoresJson
        .map((s) => ScoreEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();

    // Sort by score descending
    allScores.sort((a, b) => b.score.compareTo(a.score));

    // Keep top 10
    final topScores = allScores.take(10).toList();

    // Save back
    await prefs.setStringList(
      _highScoreKey,
      topScores.map((s) => jsonEncode(s.toJson())).toList(),
    );
  }

  Future<List<ScoreEntry>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = prefs.getStringList(_highScoreKey) ?? [];

    return scoresJson
        .map((s) => ScoreEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoreKey);
  }
}
