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
}