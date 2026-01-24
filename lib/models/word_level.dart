import 'package:flutter/material.dart';

class WordPrompt {
  final String answer;
  final String clue;

  const WordPrompt(this.answer, this.clue);
}

class WordLevel {
  final String id;
  final String title;
  final String description;
  final int roundDuration;
  final int supernovaBonus;
  final int baseScore;
  final Color accent;
  final List<WordPrompt> prompts;

  const WordLevel({
    required this.id,
    required this.title,
    required this.description,
    required this.roundDuration,
    required this.supernovaBonus,
    required this.baseScore,
    required this.accent,
    required this.prompts,
  });

  static const easy = WordLevel(
    id: 'easy',
    title: 'Easy',
    description: 'Simple words to warm up with big hints.',
    roundDuration: 20,
    supernovaBonus: 15,
    baseScore: 10,
    accent: Color(0xFF4caf50),
    prompts: [
      WordPrompt('sun', 'A bright star in the sky'),
      WordPrompt('tree', 'Green and leafy, with branches'),
      WordPrompt('book', 'Filled with pages and stories'),
    ],
  );

  static const normal = WordLevel(
    id: 'normal',
    title: 'Normal',
    description: 'Balanced challenge with concise hints.',
    roundDuration: 25,
    supernovaBonus: 35,
    baseScore: 20,
    accent: Color(0xFF2196f3),
    prompts: [
      WordPrompt('river', 'Flows and may have banks'),
      WordPrompt('mirror', 'Reflects yourself instantly'),
      WordPrompt('puzzle', 'You solve me by thinking'),
    ],
  );

  static const hard = WordLevel(
    id: 'hard',
    title: 'Hard',
    description: 'Tricky words plus minimal hints.',
    roundDuration: 30,
    supernovaBonus: 50,
    baseScore: 30,
    accent: Color(0xFF9c27b0),
    prompts: [
      WordPrompt('labyrinth', 'A maze of winding paths'),
      WordPrompt('cryptic', 'Hidden meaning in short form'),
      WordPrompt('phoenix', 'Mythical bird reborn from flames'),
    ],
  );

  static const List<WordLevel> levels = [easy, normal, hard];
}
