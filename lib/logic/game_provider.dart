import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/question_model.dart';
import '../data/repositories/question_repository.dart';
import '../data/services/score_service.dart';

enum GameStatus { initial, loading, playing, answered, won, lost }

enum GameMode { single, multiplayer }

class GameProvider extends ChangeNotifier {
  final QuestionRepository _repository = QuestionRepository();
  final ScoreService _scoreService = ScoreService();
  static const int _maxQuestionsPerGame = 10;

  List<QuestionModel> _filteredQuestions = [];
  QuestionModel? _currentQuestion;
  int? _selectedOptionIndex;
  bool? _isLastAnswerCorrect;

  // Word guess için
  final Set<String> _guessedLetters = {};
  String _currentGuess = '';

  GameMode _gameMode = GameMode.single;
  Difficulty _difficulty = Difficulty.medium;
  int _activePlayerIndex = 0;
  List<int> _playerScores = [0, 0];
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  int _currentQuestionIndex = 0;
  GameStatus _status = GameStatus.initial;

  Timer? _timer;
  int _maxTime = 30;
  int _currentTime = 30;

  // Joker sistemi
  bool _hasAskFriend = true;
  bool _hasFiftyFifty = true;
  bool _hasSkipQuestion = true;
  final Set<int> _eliminatedOptions = {};
  final Set<String> _eliminatedLetters = {};
  String? _revealedLetter;

  // Getters
  QuestionModel? get currentQuestion => _currentQuestion;
  int? get selectedOptionIndex => _selectedOptionIndex;
  bool? get isLastAnswerCorrect => _isLastAnswerCorrect;
  int get currentScore => _playerScores[_activePlayerIndex];
  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;
  GameStatus get status => _status;
  GameMode get gameMode => _gameMode;
  int get activePlayerIndex => _activePlayerIndex;
  int get player1Score => _playerScores[0];
  int get player2Score => _playerScores[1];
  int get currentTime => _currentTime;
  int get maxTime => _maxTime;
  double get timePercent => _currentTime / _maxTime;
  int get currentQuestionNumber => _currentQuestionIndex + 1;
  int get totalQuestions => _filteredQuestions.length;

  // Word guess getters
  Set<String> get guessedLetters => _guessedLetters;
  String get currentGuess => _currentGuess;
  String? get revealedLetter => _revealedLetter;

  // Joker getters
  bool get hasAskFriend => _hasAskFriend;
  bool get hasFiftyFifty => _hasFiftyFifty;
  bool get hasSkipQuestion => _hasSkipQuestion;
  Set<int> get eliminatedOptions => _eliminatedOptions;
  Set<String> get eliminatedLetters => _eliminatedLetters;

  Difficulty get difficulty => _difficulty;
  int get totalScore => _playerScores[_activePlayerIndex];

  void _setDifficultySettings() {
    switch (_difficulty) {
      case Difficulty.easy:
        _maxTime = 45;
        break;
      case Difficulty.medium:
        _maxTime = 30;
        break;
      case Difficulty.hard:
        _maxTime = 20;
        break;
    }
    _currentTime = _maxTime;
  }

  Future<void> initGame({
    required GameMode mode,
    required Difficulty difficulty,
  }) async {
    _gameMode = mode;
    _difficulty = difficulty;
    _status = GameStatus.loading;
    _playerScores = [0, 0];
    _activePlayerIndex = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _selectedOptionIndex = null;
    _isLastAnswerCorrect = null;
    _currentGuess = '';
    _guessedLetters.clear();

    // Jokerleri resetle
    _hasAskFriend = true;
    _hasFiftyFifty = true;
    _hasSkipQuestion = true;
    _eliminatedOptions.clear();
    _eliminatedLetters.clear();
    _revealedLetter = null;

    notifyListeners();

    _setDifficultySettings();
    final allQuestions = await _repository.getQuestions();

    _filteredQuestions = allQuestions.where((q) => q.difficulty == difficulty).toList();

    if (_filteredQuestions.length < 3) {
      _filteredQuestions = List.from(allQuestions);
    }

    _filteredQuestions.shuffle();
    if (_filteredQuestions.length > _maxQuestionsPerGame) {
      _filteredQuestions = _filteredQuestions.take(_maxQuestionsPerGame).toList();
    }

    _currentQuestionIndex = 0;
    _startQuestion();
  }

  void _startQuestion() {
    _cancelTimer();

    if (_filteredQuestions.isEmpty) {
      _endGame();
      return;
    }

    if (_currentQuestionIndex < _filteredQuestions.length) {
      _currentQuestion = _filteredQuestions[_currentQuestionIndex];
      _selectedOptionIndex = null;
      _isLastAnswerCorrect = null;
      _eliminatedOptions.clear();
      _eliminatedLetters.clear();
      _guessedLetters.clear();
      _currentGuess = '';
      _revealedLetter = null;
      _currentTime = _maxTime;
      _status = GameStatus.playing;
      _startTimer();
    } else {
      _endGame();
    }
    notifyListeners();
  }

  void _endGame() {
    _cancelTimer();
    if (_correctAnswers > _wrongAnswers) {
      _status = GameStatus.won;
    } else {
      _status = GameStatus.lost;
    }
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status != GameStatus.playing) {
        timer.cancel();
        return;
      }

      if (_currentTime > 0) {
        _currentTime--;
        notifyListeners();
      } else {
        timer.cancel();
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    _wrongAnswers++;
    _isLastAnswerCorrect = false;
    _status = GameStatus.answered;
    _calculateScore(isCorrect: false);
    notifyListeners();
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  // Multiple Choice için
  void selectOption(int optionIndex) {
    if (_status != GameStatus.playing ||
        _currentQuestion == null ||
        !_currentQuestion!.isMultipleChoice ||
        _eliminatedOptions.contains(optionIndex)) {
      return;
    }

    _cancelTimer();
    _selectedOptionIndex = optionIndex;
    _isLastAnswerCorrect = _currentQuestion!.isCorrectOption(optionIndex);

    if (_isLastAnswerCorrect!) {
      _correctAnswers++;
      _calculateScore(isCorrect: true);
    } else {
      _wrongAnswers++;
      _calculateScore(isCorrect: false);
    }

    _status = GameStatus.answered;
    notifyListeners();
  }

  // Word Guess için - harf tahmin et
  void guessLetter(String letter) {
    if (_status != GameStatus.playing ||
        _currentQuestion == null ||
        !_currentQuestion!.isWordGuess ||
        _guessedLetters.contains(letter) ||
        _eliminatedLetters.contains(letter)) {
      return;
    }

    _guessedLetters.add(letter);

    final answer = _currentQuestion!.answer?.toUpperCase() ?? '';
    if (!answer.contains(letter)) {
      _currentTime = (_currentTime - 3).clamp(0, _maxTime);
    }

    // Tüm harfler tahmin edildi mi kontrol et
    final allGuessed = answer.split('').every((char) => _guessedLetters.contains(char));

    if (allGuessed) {
      _cancelTimer();
      _isLastAnswerCorrect = true;
      _correctAnswers++;
      _calculateScore(isCorrect: true);
      _status = GameStatus.answered;
    }

    notifyListeners();
  }

  // Word Guess için - kelime gönder
  void submitWord(String word) {
    if (_status != GameStatus.playing ||
        _currentQuestion == null ||
        !_currentQuestion!.isWordGuess) {
      return;
    }

    _cancelTimer();
    _currentGuess = word.toUpperCase();
    _isLastAnswerCorrect = _currentQuestion!.isCorrectWord(word);

    if (_isLastAnswerCorrect!) {
      _correctAnswers++;
      _calculateScore(isCorrect: true);
    } else {
      _wrongAnswers++;
      _calculateScore(isCorrect: false);
    }

    _status = GameStatus.answered;
    notifyListeners();
  }

  void _calculateScore({required bool isCorrect}) {
    if (!isCorrect) {
      return;
    }

    int difficultyMultiplier = 1;
    if (_difficulty == Difficulty.medium) {
      difficultyMultiplier = 2;
    }
    if (_difficulty == Difficulty.hard) {
      difficultyMultiplier = 3;
    }

    int timeBonus = _currentTime * 2;
    int baseScore = 100;
    int roundScore = (baseScore + timeBonus) * difficultyMultiplier;
    _playerScores[_activePlayerIndex] += roundScore;
  }

  void nextQuestion() {
    if (_gameMode == GameMode.multiplayer) {
      _activePlayerIndex = (_activePlayerIndex + 1) % 2;
    }
    _currentQuestionIndex++;

    if (_currentQuestionIndex >= _filteredQuestions.length) {
      _endGame();
    } else {
      _startQuestion();
    }
  }

  Future<void> saveScore(String playerName, int avatarIndex) async {
    String diffName = _difficulty.name.toUpperCase();

    if (_gameMode == GameMode.single) {
      await _scoreService.saveScore(
        score: _playerScores[0],
        playerName: playerName,
        difficultyName: diffName,
        avatarIndex: avatarIndex,
      );
    } else {
      await _scoreService.saveScore(
        score: _playerScores[0],
        playerName: "$playerName (P1)",
        difficultyName: diffName,
        avatarIndex: avatarIndex,
      );
      await _scoreService.saveScore(
        score: _playerScores[1],
        playerName: "$playerName (P2)",
        difficultyName: diffName,
        avatarIndex: avatarIndex,
      );
    }
  }

  // --- JOKER FONKSİYONLARI ---

  // Multiple Choice: Doğru cevabı gösterir
  // Word Guess: Bir harfi açar
  dynamic useAskFriend() {
    if (!_hasAskFriend || _currentQuestion == null || _status != GameStatus.playing) {
      return null;
    }

    _hasAskFriend = false;

    if (_currentQuestion!.isMultipleChoice) {
      notifyListeners();
      return _currentQuestion!.correctIndex;
    } else {
      // Word guess - bir harf aç
      final answer = _currentQuestion!.answer?.toUpperCase() ?? '';
      final unguessed = answer.split('').where((c) => !_guessedLetters.contains(c)).toSet().toList();
      if (unguessed.isNotEmpty) {
        unguessed.shuffle();
        _revealedLetter = unguessed.first;
        _guessedLetters.add(_revealedLetter!);

        // Tüm harfler tahmin edildi mi kontrol et
        final allGuessed = answer.split('').every((char) => _guessedLetters.contains(char));
        if (allGuessed) {
          _cancelTimer();
          _isLastAnswerCorrect = true;
          _correctAnswers++;
          _calculateScore(isCorrect: true);
          _status = GameStatus.answered;
        }

        notifyListeners();
        return _revealedLetter;
      }
    }

    notifyListeners();
    return null;
  }

  // Multiple Choice: 2 yanlış şıkkı eler
  // Word Guess: 3 yanlış harfi eler
  List<dynamic> useFiftyFifty() {
    if (!_hasFiftyFifty || _currentQuestion == null || _status != GameStatus.playing) {
      return [];
    }

    _hasFiftyFifty = false;

    if (_currentQuestion!.isMultipleChoice && _currentQuestion!.options != null) {
      final wrongOptions = <int>[];
      for (int i = 0; i < _currentQuestion!.options!.length; i++) {
        if (i != _currentQuestion!.correctIndex && !_eliminatedOptions.contains(i)) {
          wrongOptions.add(i);
        }
      }

      wrongOptions.shuffle();
      final toEliminate = wrongOptions.take(2).toList();
      _eliminatedOptions.addAll(toEliminate);

      notifyListeners();
      return toEliminate;
    } else {
      // Word guess - yanlış harfleri ele
      const turkishAlphabet = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';
      final answer = _currentQuestion!.answer?.toUpperCase() ?? '';

      final wrongLetters = turkishAlphabet.split('').where((letter) =>
          !answer.contains(letter) &&
          !_guessedLetters.contains(letter) &&
          !_eliminatedLetters.contains(letter)).toList();

      wrongLetters.shuffle();
      final toEliminate = wrongLetters.take(3).toList();
      _eliminatedLetters.addAll(toEliminate);

      notifyListeners();
      return toEliminate;
    }
  }

  // Soruyu Geç
  void useSkipQuestion() {
    if (!_hasSkipQuestion || _status != GameStatus.playing) {
      return;
    }

    _hasSkipQuestion = false;
    _cancelTimer();
    _currentQuestionIndex++;
    _eliminatedOptions.clear();
    _eliminatedLetters.clear();

    if (_currentQuestionIndex >= _filteredQuestions.length) {
      _endGame();
    } else {
      _startQuestion();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
