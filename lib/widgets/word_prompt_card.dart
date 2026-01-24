import 'package:flutter/material.dart';

import '../models/word_level.dart';

class WordPromptCard extends StatelessWidget {
  final WordPrompt prompt;

  const WordPromptCard({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
        gradient: LinearGradient(
          colors: [Colors.white10, Colors.white12],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Clue', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Text(prompt.clue, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
