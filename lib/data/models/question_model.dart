enum Difficulty { easy, medium, hard }

enum QuestionType { multipleChoice, wordGuess }

class QuestionModel {
  final String id;
  final String question;
  final QuestionType type;
  final List<String>? options;
  final int? correctIndex;
  final String? answer;
  final String? hint;
  final Difficulty difficulty;
  final String? imageUrl;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.type,
    this.options,
    this.correctIndex,
    this.answer,
    this.hint,
    required this.difficulty,
    this.imageUrl,
  });

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  bool get isMultipleChoice => type == QuestionType.multipleChoice;

  bool get isWordGuess => type == QuestionType.wordGuess;

  String get correctAnswer {
    if (isMultipleChoice && options != null && correctIndex != null) {
      return options![correctIndex!];
    }
    return answer ?? '';
  }

  bool isCorrectOption(int selectedIndex) {
    return isMultipleChoice && selectedIndex == correctIndex;
  }

  bool isCorrectWord(String guessedWord) {
    return isWordGuess && guessedWord.toUpperCase() == answer?.toUpperCase();
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'multiple_choice';
    final type = typeStr == 'word_guess' ? QuestionType.wordGuess : QuestionType.multipleChoice;

    return QuestionModel(
      id: json['id'] as String,
      question: json['question'] as String,
      type: type,
      options: json['options'] != null ? List<String>.from(json['options'] as List) : null,
      correctIndex: json['correctIndex'] as int?,
      answer: json['answer'] as String?,
      hint: json['hint'] as String?,
      difficulty: _parseDifficulty(json['difficulty'] as String),
      imageUrl: json['imageUrl'] as String?,
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
      'question': question,
      'type': type == QuestionType.wordGuess ? 'word_guess' : 'multiple_choice',
      if (options != null) 'options': options,
      if (correctIndex != null) 'correctIndex': correctIndex,
      if (answer != null) 'answer': answer,
      if (hint != null) 'hint': hint,
      'difficulty': difficulty.name,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
