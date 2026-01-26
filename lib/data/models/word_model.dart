enum Difficulty { easy, medium, hard }

class WordModel {
  final String id;
  final String word;
  final String hint;
  final Difficulty difficulty;

  WordModel({
    required this.id,
    required this.word,
    required this.hint,
    required this.difficulty,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as String,
      word: json['word'] as String,
      hint: json['hint'] as String,
      difficulty: _parseDifficulty(json['difficulty'] as String),
    );
  }

  static Difficulty _parseDifficulty(String value) {
    switch (value) {
      case 'easy':
        return Difficulty.easy;
      case 'medium':
        return Difficulty.medium;
      case 'hard':
        return Difficulty.hard;
      default:
        return Difficulty.easy;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'hint': hint,
      'difficulty': difficulty.name,
    };
  }
}
