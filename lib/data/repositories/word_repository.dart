import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word_model.dart';

class WordRepository {
  List<WordModel>? _cachedWords;

  Future<List<WordModel>> getWords() async {
    if (_cachedWords != null) {
      return _cachedWords!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/questions.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final questionsList = jsonData['questions'] as List<dynamic>;

      _cachedWords = questionsList
          .map((q) => WordModel.fromJson(q as Map<String, dynamic>))
          .toList();

      return _cachedWords!;
    } catch (e) {
      // Fallback to hardcoded words if JSON loading fails
      return _getFallbackWords();
    }
  }

  List<WordModel> _getFallbackWords() {
    return [
      WordModel(
        id: '1',
        word: "NAMAZ",
        hint: "Dinin direği",
        difficulty: Difficulty.easy,
      ),
      WordModel(
        id: '2',
        word: "ORUÇ",
        hint: "Ramazan ayı ibadeti",
        difficulty: Difficulty.easy,
      ),
      WordModel(
        id: '3',
        word: "KURAN",
        hint: "Kutsal kitabımız",
        difficulty: Difficulty.easy,
      ),
      WordModel(
        id: '4',
        word: "ZEKAT",
        hint: "Malın temizlenmesi",
        difficulty: Difficulty.medium,
      ),
      WordModel(
        id: '5',
        word: "HİCRET",
        hint: "Mekke'den Medine'ye göç",
        difficulty: Difficulty.medium,
      ),
      WordModel(
        id: '6',
        word: "TEVEKKÜL",
        hint: "Allah'a güvenme",
        difficulty: Difficulty.hard,
      ),
    ];
  }

  void clearCache() {
    _cachedWords = null;
  }
}
