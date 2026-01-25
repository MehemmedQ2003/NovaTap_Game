import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../logic/game_provider.dart';
import '../components/letter_box.dart';
import '../components/custom_keyboard.dart';
import '../components/timer_widget.dart';
import 'result_page.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (game.status == GameStatus.won || game.status == GameStatus.lost) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultPage()),
        );
      }
    });

    if (game.status == GameStatus.loading || game.currentWord == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          game.gameMode == GameMode.single
              ? "Puan: ${game.currentScore}"
              : "Sıra: OYUNCU ${game.activePlayerIndex + 1}",
        ),
        backgroundColor: AppColors.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                game.lives,
                (i) => const Icon(Icons.favorite, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ÜST BİLGİ PANELİ
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (game.gameMode == GameMode.multiplayer)
                  Text(
                    "O1: ${game.player1Score} - O2: ${game.player2Score}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                // ZAMAN SAYACI BURADA
                TimerWidget(
                  currentTime: game.currentTime,
                  percent: game.timePercent,
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // İPUCU
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent, width: 2),
                    ),
                    child: Text(
                      "İPUCU: ${game.currentWord!.hint}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subHeading.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // KELİME
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: game.currentWord!.word.split('').map((char) {
                      return LetterBox(
                        letter: char,
                        isRevealed: game.guessedLetters.contains(char),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // KLAVYE
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: CustomKeyboard(
              onKeyPress: game.guessLetter,
              disabledKeys: game.guessedLetters,
            ),
          ),
        ],
      ),
    );
  }
}
