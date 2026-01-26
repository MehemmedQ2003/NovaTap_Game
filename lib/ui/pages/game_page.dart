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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (game.status == GameStatus.won || game.status == GameStatus.lost) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultPage()),
        );
      }
    });

    if (game.status == GameStatus.loading || game.currentWord == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: isDark ? AppColors.primaryDarkTheme : AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: Text(
          game.gameMode == GameMode.single
              ? "Puan: ${game.currentScore}"
              : "Sıra: OYUNCU ${game.activePlayerIndex + 1}",
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                game.lives,
                (i) => const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.favorite, color: Colors.red, size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ÜST BİLGİ PANELİ
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: isDark ? AppColors.surfaceDark : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (game.gameMode == GameMode.multiplayer)
                  Text(
                    "O1: ${game.player1Score} - O2: ${game.player2Score}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                if (game.gameMode == GameMode.single) const SizedBox(),

                // ZAMAN SAYACI
                TimerWidget(
                  currentTime: game.currentTime,
                  percent: game.timePercent,
                ),
              ],
            ),
          ),

          // JOKER BUTONLARI
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: isDark ? AppColors.cardBackgroundDark : AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _JokerButton(
                  icon: Icons.phone,
                  label: 'Arkadaş',
                  isAvailable: game.hasAskFriend,
                  onTap: () => _useAskFriend(context, game),
                  isDark: isDark,
                ),
                _JokerButton(
                  icon: Icons.exposure_minus_2,
                  label: '50/50',
                  isAvailable: game.hasFiftyFifty,
                  onTap: () => _useFiftyFifty(context, game),
                  isDark: isDark,
                ),
                _JokerButton(
                  icon: Icons.skip_next,
                  label: 'Pas Geç',
                  isAvailable: game.hasSkipQuestion,
                  onTap: () => _useSkipQuestion(context, game),
                  isDark: isDark,
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
                      color: isDark
                          ? AppColors.accent.withValues(alpha: 0.15)
                          : AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "İPUCU: ${game.currentWord!.hint}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.accent : AppColors.primaryDark,
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
            color: isDark ? AppColors.surfaceDark : Colors.white,
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: CustomKeyboard(
              onKeyPress: game.guessLetter,
              disabledKeys: {...game.guessedLetters, ...game.eliminatedLetters},
              eliminatedKeys: game.eliminatedLetters,
            ),
          ),
        ],
      ),
    );
  }

  void _useAskFriend(BuildContext context, GameProvider game) {
    final letter = game.useAskFriend();
    if (letter != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Arkadaşın "$letter" harfini önerdi!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _useFiftyFifty(BuildContext context, GameProvider game) {
    final eliminated = game.useFiftyFifty();
    if (eliminated.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${eliminated.join(", ")} harfleri elendi!'),
          backgroundColor: AppColors.timerNormal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _useSkipQuestion(BuildContext context, GameProvider game) {
    game.useSkipQuestion();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Soru atlandı!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _JokerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAvailable;
  final VoidCallback onTap;
  final bool isDark;

  const _JokerButton({
    required this.icon,
    required this.label,
    required this.isAvailable,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isAvailable
              ? LinearGradient(
                  colors: isDark
                      ? [AppColors.primaryDarkTheme, AppColors.primaryDarkDarkTheme]
                      : [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isAvailable ? null : (isDark ? AppColors.neutralDark : AppColors.neutralLight),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isAvailable
              ? [
                  BoxShadow(
                    color: (isDark ? AppColors.primaryDarkTheme : AppColors.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isAvailable
                  ? Colors.white
                  : (isDark ? AppColors.neutral : AppColors.neutral),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isAvailable
                    ? Colors.white
                    : (isDark ? AppColors.neutral : AppColors.neutral),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
