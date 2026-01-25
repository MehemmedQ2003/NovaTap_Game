import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  static const String _highScoreKey = 'high_scores_v2';

  Future<void> saveScore(
    int score,
    String playerName,
    String difficultyName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> scores = prefs.getStringList(_highScoreKey) ?? [];

    scores.add("$playerName ($difficultyName):$score");

    scores.sort((a, b) {
      int scoreA = int.parse(a.split(':')[1]);
      int scoreB = int.parse(b.split(':')[1]);
      return scoreB.compareTo(scoreA);
    });

    if (scores.length > 10) scores = scores.sublist(0, 10);
    await prefs.setStringList(_highScoreKey, scores);
  }

  Future<List<Map<String, dynamic>>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> scores = prefs.getStringList(_highScoreKey) ?? [];

    return scores.map((e) {
      final parts = e.split(':');
      return {'name': parts[0], 'score': int.parse(parts[1])};
    }).toList();
  }
}
