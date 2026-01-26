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
  static const int _maxQuestionsPerDifficulty = 10;

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

  // Joker sistemi
  bool _hasAskFriend = true;
  bool _hasFiftyFifty = true;
  bool _hasSkipQuestion = true;
  Set<String> _eliminatedLetters = {};

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

  // Joker getters
  bool get hasAskFriend => _hasAskFriend;
  bool get hasFiftyFifty => _hasFiftyFifty;
  bool get hasSkipQuestion => _hasSkipQuestion;
  Set<String> get eliminatedLetters => _eliminatedLetters;

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

    // Jokerleri resetle
    _hasAskFriend = true;
    _hasFiftyFifty = true;
    _hasSkipQuestion = true;
    _eliminatedLetters.clear();

    notifyListeners();

    _setDifficultySettings();
    final allWords = await _repository.getWords();

    _filteredWords = allWords.where((w) => w.difficulty == difficulty).toList();

    if (_filteredWords.length < 3) {
      _filteredWords = List.from(allWords);
    }

    _filteredWords.shuffle();
    if (_filteredWords.length > _maxQuestionsPerDifficulty) {
      _filteredWords = _filteredWords.take(_maxQuestionsPerDifficulty).toList();
    }

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
      _eliminatedLetters.clear(); // Elenen harfleri temizle
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

  int get totalScore => _playerScores[_activePlayerIndex];
  Difficulty get difficulty => _difficulty;
  int get maxTime => _maxTime;

  // --- JOKER FONKSİYONLARI ---

  // Arkadaşı Ara: Doğru bir harfi gösterir
  String? useAskFriend() {
    if (!_hasAskFriend || _currentWord == null) return null;

    _hasAskFriend = false;

    // Henüz tahmin edilmemiş harfleri bul
    final unguessedLetters = _currentWord!.word
        .split('')
        .where((letter) => !_guessedLetters.contains(letter))
        .toSet()
        .toList();

    if (unguessedLetters.isEmpty) return null;

    // Rastgele bir doğru harf seç
    unguessedLetters.shuffle();
    final revealedLetter = unguessedLetters.first;

    // Harfi otomatik tahmin et
    _guessedLetters.add(revealedLetter);
    _playerScores[_activePlayerIndex] += 5; // Yarım puan

    _checkGameStatus();
    notifyListeners();

    return revealedLetter;
  }

  // 50/50: Yanlış 2 harfi klavyeden kaldırır
  List<String> useFiftyFifty() {
    if (!_hasFiftyFifty || _currentWord == null) return [];

    _hasFiftyFifty = false;

    const turkishAlphabet = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';

    // Kelimede olmayan ve henüz elenmemiş harfleri bul
    final wrongLetters = turkishAlphabet
        .split('')
        .where(
          (letter) =>
              !_currentWord!.word.contains(letter) &&
              !_guessedLetters.contains(letter) &&
              !_eliminatedLetters.contains(letter),
        )
        .toList();

    wrongLetters.shuffle();

    // En fazla 2 harf ele
    final toEliminate = wrongLetters.take(2).toList();
    _eliminatedLetters.addAll(toEliminate);

    notifyListeners();
    return toEliminate;
  }

  // Soruyu Geç: Mevcut soruyu atlar
  void useSkipQuestion() {
    if (!_hasSkipQuestion) return;

    _hasSkipQuestion = false;
    _cancelTimer();

    // Sonraki soruya geç (puan kaybı yok)
    _currentLevelIndex++;
    _eliminatedLetters.clear();
    _startLevel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
