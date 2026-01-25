import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/word_model.dart';
import '../data/repositories/word_repository.dart';
import '../data/services/score_service.dart';

enum GameStatus { initial, loading, playing, won, lost }

enum GameMode { single, multiplayer }

class GameProvider extends ChangeNotifier {
  final WordRepository _repository = WordRepository();
  final ScoreService _scoreService = ScoreService();

  List<WordModel> _filteredWords = [];
  WordModel? _currentWord;
  Set<String> _guessedLetters = {};

  GameMode _gameMode = GameMode.single;
  Difficulty _difficulty = Difficulty.medium;
  int _activePlayerIndex = 0;
  List<int> _playerScores = [0, 0];
  int _lives = 5;
  int _currentLevelIndex = 0;
  GameStatus _status = GameStatus.initial;

  Timer? _timer;
  int _maxTime = 60;
  int _currentTime = 60;

  WordModel? get currentWord => _currentWord;
  Set<String> get guessedLetters => _guessedLetters;
  int get currentScore => _playerScores[_activePlayerIndex];
  int get lives => _lives;
  GameStatus get status => _status;
  GameMode get gameMode => _gameMode;
  int get activePlayerIndex => _activePlayerIndex;
  int get player1Score => _playerScores[0];
  int get player2Score => _playerScores[1];
  int get currentTime => _currentTime;
  double get timePercent => _currentTime / _maxTime;

  void _setDifficultySettings() {
    switch (_difficulty) {
      case Difficulty.easy:
        _maxTime = 90;
        break;
      case Difficulty.medium:
        _maxTime = 60;
        break;
      case Difficulty.hard:
        _maxTime = 30;
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
    notifyListeners();

    _setDifficultySettings();
    final allWords = await _repository.getWords();

    _filteredWords = allWords.where((w) => w.difficulty == difficulty).toList();

    if (_filteredWords.length < 3) {
      _filteredWords = List.from(allWords);
    }

    _filteredWords.shuffle();
    _currentLevelIndex = 0;
    _startLevel();
  }

  void _startLevel() {
    _cancelTimer();

    if (_filteredWords.isEmpty) {
      _allWordsCompleted();
      return;
    }

    if (_currentLevelIndex < _filteredWords.length) {
      _currentWord = _filteredWords[_currentLevelIndex];
      _guessedLetters.clear();
      _lives = 3; // Can sayısı sabitlendi
      _currentTime = _maxTime; // Süreyi sıfırla
      _status = GameStatus.playing;
      _startTimer(); // Sayacı başlat
    } else {
      _allWordsCompleted();
    }
    notifyListeners();
  }

  void _allWordsCompleted() {
    // Kelimeler bitince listeyi tekrar karıştır
    _filteredWords.shuffle();
    _currentLevelIndex = 0;
    _startLevel();
  }

  // --- TIMER MANTIĞI ---
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
        // Süre bitti!
        timer.cancel();
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    _lives--;
    if (_lives <= 0) {
      _status = GameStatus.lost;
      _calculateScore(isWin: false);
    } else {
      // Süre bitti ama can var, süreyi resetle devam et
      _currentTime = _maxTime;
      _startTimer();
    }
    notifyListeners();
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  // --- OYUN İŞLEMLERİ ---

  void guessLetter(String letter) {
    if (_status != GameStatus.playing || _guessedLetters.contains(letter))
      return;

    _guessedLetters.add(letter);

    if (!_currentWord!.word.contains(letter)) {
      _lives--;
      // Yanlış bilince süre cezası (Opsiyonel)
      // _currentTime = (_currentTime - 5).clamp(0, _maxTime);
    } else {
      // Doğru harf puanı
      _playerScores[_activePlayerIndex] += 10;
    }

    _checkGameStatus();
    notifyListeners();
  }

  void _checkGameStatus() {
    if (_lives <= 0) {
      _status = GameStatus.lost;
      _cancelTimer();
      _calculateScore(isWin: false);
    } else {
      bool allGuessed = _currentWord!.word
          .split('')
          .every((char) => _guessedLetters.contains(char));
      if (allGuessed) {
        _status = GameStatus.won;
        _cancelTimer();
        _calculateScore(isWin: true);
      }
    }
  }

  void _calculateScore({required bool isWin}) {
    if (!isWin) {
      _playerScores[_activePlayerIndex] =
          (_playerScores[_activePlayerIndex] - 50).clamp(0, 99999);
      return;
    }

    // Puan Formülü: (Kalan Süre + Kalan Can) * Zorluk Çarpanı
    int difficultyMultiplier = 1;
    if (_difficulty == Difficulty.medium) difficultyMultiplier = 2;
    if (_difficulty == Difficulty.hard) difficultyMultiplier = 3;

    int roundScore = (_currentTime + (_lives * 10)) * difficultyMultiplier;
    _playerScores[_activePlayerIndex] += roundScore;
  }

  void nextLevel() {
    if (_gameMode == GameMode.multiplayer) {
      _activePlayerIndex = (_activePlayerIndex + 1) % 2;
    }
    _currentLevelIndex++;
    _startLevel();
  }

  // --- GÜNCELLENEN KISIM BURASI ---
  // Artık parametre olarak 'playerName' alıyor
  Future<void> saveScore(String playerName) async {
    String diffName = _difficulty.name.toUpperCase();

    if (_gameMode == GameMode.single) {
      // Tek kişilikse direkt ismi kaydet
      await _scoreService.saveScore(_playerScores[0], playerName, diffName);
    } else {
      // Çok kişilikse isimlerin yanına P1/P2 ekle
      await _scoreService.saveScore(
        _playerScores[0],
        "$playerName (P1)",
        diffName,
      );
      await _scoreService.saveScore(
        _playerScores[1],
        "$playerName (P2)",
        diffName,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
