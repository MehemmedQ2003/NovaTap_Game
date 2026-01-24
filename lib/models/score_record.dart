class ScoreRecord {
  final int score;
  final DateTime recordedAt;
  final String levelId;
  final String levelName;

  const ScoreRecord(this.score, this.recordedAt,
      {required this.levelId, required this.levelName});
}
