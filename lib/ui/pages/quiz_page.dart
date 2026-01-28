import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../data/models/question_model.dart';
import '../../logic/game_provider.dart';
import '../components/timer_widget.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  static const List<String> _optionLabels = ['A', 'B', 'C', 'D', 'E'];
  static const List<String> _turkishAlphabet = [
    'A',
    'B',
    'C',
    'Ç',
    'D',
    'E',
    'F',
    'G',
    'Ğ',
    'H',
    'I',
    'İ',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'Ö',
    'P',
    'R',
    'S',
    'Ş',
    'T',
    'U',
    'Ü',
    'V',
    'Y',
    'Z',
  ];

  final TextEditingController _wordController = TextEditingController();

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

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

    if (game.status == GameStatus.loading || game.currentQuestion == null) {
      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: isDark ? AppColors.primaryDarkTheme : AppColors.primary,
          ),
        ),
      );
    }

    final question = game.currentQuestion!;
    final options = question.options ?? [];
    final isAnswered = game.status == GameStatus.answered;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: Text(
          game.gameMode == GameMode.single
              ? "Soru ${game.currentQuestionNumber}/${game.totalQuestions}"
              : "Sıra: OYUNCU ${game.activePlayerIndex + 1}",
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  "${game.currentScore}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Üst bilgi paneli
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: isDark ? AppColors.surfaceDark : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Doğru/Yanlış sayacı
                Row(
                  children: [
                    _StatBadge(
                      icon: Icons.check_circle,
                      value: game.correctAnswers,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    _StatBadge(
                      icon: Icons.cancel,
                      value: game.wrongAnswers,
                      color: AppColors.failure,
                    ),
                  ],
                ),
                // Timer
                TimerWidget(
                  currentTime: game.currentTime,
                  percent: game.timePercent,
                ),
              ],
            ),
          ),

          // Joker butonları
          if (!isAnswered)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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

          // Ana içerik
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Resim
                  if (question.hasImage)
                    Container(
                      height: 180,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          question.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.surface,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: isDark
                                      ? AppColors.primaryDarkTheme
                                      : AppColors.primary,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.surface,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 48,
                                  color: isDark
                                      ? AppColors.neutral
                                      : AppColors.neutralLight,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Soru
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.cardBackgroundDark
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textDark,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (question.isMultipleChoice && options.isNotEmpty)
                    ...List.generate(options.length, (index) {
                      final isEliminated = game.eliminatedOptions.contains(
                        index,
                      );
                      final isSelected = game.selectedOptionIndex == index;
                      final isCorrect =
                          question.correctIndex != null &&
                          index == question.correctIndex;

                      Color? backgroundColor;
                      Color? borderColor;
                      Color textColor = isDark
                          ? AppColors.textLight
                          : AppColors.textDark;

                      if (isAnswered) {
                        if (isCorrect) {
                          backgroundColor = AppColors.success.withValues(
                            alpha: 0.2,
                          );
                          borderColor = AppColors.success;
                          textColor = AppColors.success;
                        } else if (isSelected && !isCorrect) {
                          backgroundColor = AppColors.failure.withValues(
                            alpha: 0.2,
                          );
                          borderColor = AppColors.failure;
                          textColor = AppColors.failure;
                        }
                      }

                      if (isEliminated) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _OptionButton(
                          label: _optionLabels[index],
                          text: options[index],
                          isSelected: isSelected,
                          isCorrect: isAnswered && isCorrect,
                          isWrong: isAnswered && isSelected && !isCorrect,
                          backgroundColor: backgroundColor,
                          borderColor: borderColor,
                          textColor: textColor,
                          isDark: isDark,
                          onTap: isAnswered
                              ? null
                              : () => game.selectOption(index),
                        ),
                      );
                    })
                  else if (question.isWordGuess)
                    _buildWordGuessSection(question, game, isDark, isAnswered),

                  // Sonraki soru butonu
                  if (isAnswered) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: game.isLastAnswerCorrect == true
                              ? AppColors.success
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => game.nextQuestion(),
                        child: Text(
                          game.currentQuestionNumber < game.totalQuestions
                              ? "Sonraki Soru"
                              : "Sonuçları Gör",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordGuessSection(
    QuestionModel question,
    GameProvider game,
    bool isDark,
    bool isAnswered,
  ) {
    final answer = (question.answer ?? '').toUpperCase();
    final guessedLetters = game.guessedLetters;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if ((question.hint ?? '').isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              question.hint!,
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.neutral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(height: 12),
        if (answer.isNotEmpty)
          _buildWordPlaceholder(answer, guessedLetters, isDark),
        const SizedBox(height: 12),
        if (game.revealedLetter != null)
          Text(
            'Açılan harf: ${game.revealedLetter}',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _turkishAlphabet
                .map(
                  (letter) =>
                      _buildLetterKey(letter, game, answer, isDark, isAnswered),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _wordController,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleWordSubmit(game),
          decoration: InputDecoration(
            labelText: 'Kelime Tahmini',
            hintText: 'Örn: KURAN',
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : AppColors.neutralLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.neutralDark : AppColors.neutralLight,
              ),
            ),
          ),
          enabled: !isAnswered,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isAnswered
                  ? AppColors.neutralLight
                  : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isAnswered ? null : () => _handleWordSubmit(game),
            child: const Text(
              'Tahmini Gönder',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (game.currentGuess.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Tahmin edilen: ${game.currentGuess}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          ),
        if (isAnswered && answer.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Doğru cevap: $answer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: game.isLastAnswerCorrect == true
                    ? AppColors.success
                    : AppColors.failure,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWordPlaceholder(
    String answer,
    Set<String> guessedLetters,
    bool isDark,
  ) {
    final letters = answer.split('');
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: letters.map((letter) {
        final isSpace = letter.trim().isEmpty;
        final hasRevealed = isSpace || guessedLetters.contains(letter);
        final displayChar = isSpace ? '' : (hasRevealed ? letter : '_');
        return Container(
          width: 42,
          height: 52,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasRevealed
                  ? AppColors.primary
                  : (isDark ? AppColors.neutralDark : AppColors.neutralLight),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              displayChar,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLetterKey(
    String letter,
    GameProvider game,
    String answer,
    bool isDark,
    bool isAnswered,
  ) {
    final isGuessed = game.guessedLetters.contains(letter);
    final isEliminated = game.eliminatedLetters.contains(letter);
    final letterInAnswer = answer.contains(letter);
    final isDisabled = isAnswered || isEliminated || isGuessed;

    Color backgroundColor;
    Color textColor = Colors.white;

    if (isEliminated) {
      backgroundColor = isDark ? AppColors.neutralDark : AppColors.neutralLight;
      textColor = isDark ? AppColors.textLight : AppColors.textSecondary;
    } else if (isGuessed && letterInAnswer) {
      backgroundColor = AppColors.success;
    } else if (isGuessed) {
      backgroundColor = AppColors.failure;
    } else {
      backgroundColor = isDark ? AppColors.primaryDarkTheme : AppColors.primary;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isDisabled ? 0.6 : 1,
      child: GestureDetector(
        onTap: isDisabled ? null : () => game.guessLetter(letter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            letter,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  void _handleWordSubmit(GameProvider game) {
    final guess = _wordController.text.trim();
    if (guess.isEmpty || game.status != GameStatus.playing) return;
    game.submitWord(guess);
    _wordController.clear();
  }

  void _useAskFriend(BuildContext context, GameProvider game) {
    final correctIndex = game.useAskFriend();
    if (correctIndex != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Arkadaşın "${_optionLabels[correctIndex]}" şıkkını önerdi!',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _useFiftyFifty(BuildContext context, GameProvider game) {
    final eliminated = game.useFiftyFifty();
    if (eliminated.isNotEmpty) {
      final labels = eliminated.map((i) => _optionLabels[i]).join(", ");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$labels şıkları elendi!'),
          backgroundColor: AppColors.timerNormal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          "$value",
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color textColor;
  final bool isDark;
  final VoidCallback? onTap;

  const _OptionButton({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    this.backgroundColor,
    this.borderColor,
    required this.textColor,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                (isDark ? AppColors.cardBackgroundDark : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  borderColor ??
                  (isSelected
                      ? (isDark
                            ? AppColors.primaryDarkTheme
                            : AppColors.primary)
                      : (isDark
                            ? AppColors.neutralDark
                            : AppColors.neutralLight)),
              width: isSelected || isCorrect || isWrong ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Şık etiketi (A, B, C, D, E)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.success
                      : isWrong
                      ? AppColors.failure
                      : (isDark
                            ? AppColors.primaryDarkTheme
                            : AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Şık metni
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              // Doğru/Yanlış ikonu
              if (isCorrect)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                )
              else if (isWrong)
                const Icon(Icons.cancel, color: AppColors.failure, size: 24),
            ],
          ),
        ),
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
                      ? [
                          AppColors.primaryDarkTheme,
                          AppColors.primaryDarkDarkTheme,
                        ]
                      : [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isAvailable
              ? null
              : (isDark ? AppColors.neutralDark : AppColors.neutralLight),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isAvailable
              ? [
                  BoxShadow(
                    color:
                        (isDark
                                ? AppColors.primaryDarkTheme
                                : AppColors.primary)
                            .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
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
