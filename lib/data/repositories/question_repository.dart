import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuestionRepository {
  List<QuestionModel>? _cachedQuestions;

  Future<List<QuestionModel>> getQuestions() async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/questions.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final questionsList = jsonData['questions'] as List<dynamic>;

      _cachedQuestions = questionsList
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList();

      return _cachedQuestions!;
    } catch (e) {
      return _getFallbackQuestions();
    }
  }

  List<QuestionModel> _getFallbackQuestions() {
    return const [
      QuestionModel(
        id: '1',
        question: 'Günde kaç vakit namaz kılınır?',
        type: QuestionType.multipleChoice,
        options: ['3 vakit', '4 vakit', '5 vakit', '6 vakit', '7 vakit'],
        correctIndex: 2,
        difficulty: Difficulty.easy,
        imageUrl:
            'https://images.unsplash.com/photo-1591604466107-ec97de577aff?w=800',
      ),
      QuestionModel(
        id: '2',
        question: 'Kabe hangi şehirde bulunmaktadır?',
        type: QuestionType.multipleChoice,
        options: ['Medine', 'Mekke', 'Kudüs', 'İstanbul', 'Kahire'],
        correctIndex: 1,
        difficulty: Difficulty.easy,
        imageUrl:
            'https://images.unsplash.com/photo-1580418827493-f2b22c0a76cb?w=800',
      ),
      QuestionModel(
        id: '3',
        question: 'İslam’ın kutsal kitabı hangisidir?',
        type: QuestionType.multipleChoice,
        options: ['Tevrat', 'Zebur', 'İncil', 'Kuran-ı Kerim', 'Suhuf'],
        correctIndex: 3,
        difficulty: Difficulty.easy,
        imageUrl:
            'https://images.unsplash.com/photo-1609599006353-e629aaabfeae?w=800',
      ),
      QuestionModel(
        id: '4',
        question: 'Zenginlerin mallarından fakirlere verdikleri paya ne denir?',
        type: QuestionType.multipleChoice,
        options: ['Sadaka', 'Fitre', 'Zekat', 'Kurban', 'Adak'],
        correctIndex: 2,
        difficulty: Difficulty.medium,
        imageUrl:
            'https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?w=800',
      ),
      QuestionModel(
        id: '5',
        question: 'Hz. Muhammed’in Mekke’den Medine’ye göçüne ne denir?',
        type: QuestionType.multipleChoice,
        options: ['İsra', 'Miraç', 'Hicret', 'Fetih', 'Biat'],
        correctIndex: 2,
        difficulty: Difficulty.medium,
        imageUrl:
            'https://images.unsplash.com/photo-1473172707857-f9e276582ab6?w=800',
      ),
      QuestionModel(
        id: '6',
        question: 'Allah’a güvenip bağlanma anlamına gelen kavram nedir?',
        type: QuestionType.multipleChoice,
        options: ['Takva', 'Tevekkül', 'Teslimiyet', 'Tefekkür', 'Tövbe'],
        correctIndex: 1,
        difficulty: Difficulty.hard,
        imageUrl:
            'https://images.unsplash.com/photo-1507692049790-de58290a4334?w=800',
      ),
    ];
  }

  void clearCache() {
    _cachedQuestions = null;
  }
}
