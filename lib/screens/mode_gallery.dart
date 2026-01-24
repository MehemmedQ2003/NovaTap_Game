import 'package:flutter/material.dart';

import '../models/word_level.dart';

class ModeGalleryPage extends StatelessWidget {
  final ValueChanged<WordLevel> onSelectMode;

  const ModeGalleryPage({super.key, required this.onSelectMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode Gallery'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: WordLevel.levels.length,
        itemBuilder: (context, index) {
          final mode = WordLevel.levels[index];
          return Card(
            color: mode.accent.withOpacity(0.2),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(mode.title,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: mode.accent)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: mode.accent),
                        onPressed: () => onSelectMode(mode),
                        child: const Text('Play'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(mode.description, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text('Duration ${mode.roundDuration}s • Bonus +${mode.supernovaBonus}%',
                      style: const TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
