import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../../core/constants.dart';
import '../../logic/game_provider.dart';
import '../../logic/auth_provider.dart';
import 'game_page.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );

    // Animasyonları başlat
    Future.delayed(const Duration(milliseconds: 100), () {
      _scaleController.forward();
      _bounceController.forward();

      final game = context.read<GameProvider>();
      if (game.status == GameStatus.won) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameProvider>();
    final auth = context.read<AuthProvider>();
    final isWon = game.status == GameStatus.won;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isWon) {
        game.saveScore(
          auth.currentUser?.name ?? "Misafir",
          auth.currentUser?.avatarIndex ?? 0,
        );
      }
    });

    return Scaffold(
      backgroundColor: isWon
          ? (isDark ? const Color(0xFF1B3D2F) : AppColors.success)
          : (isDark ? const Color(0xFF3D1B1B) : AppColors.failure),
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
                Colors.red,
              ],
            ),
          ),

          // Sol üst confetti
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 4,
              maxBlastForce: 7,
              minBlastForce: 3,
              emissionFrequency: 0.03,
              numberOfParticles: 15,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.amber,
                Colors.cyan,
                Colors.lime,
                Colors.indigo,
              ],
            ),
          ),

          // Sağ üst confetti
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -3 * pi / 4,
              maxBlastForce: 7,
              minBlastForce: 3,
              emissionFrequency: 0.03,
              numberOfParticles: 15,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.teal,
                Colors.deepOrange,
                Colors.lightBlue,
                Colors.pinkAccent,
              ],
            ),
          ),

          // Ana içerik
          Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animasyonlu ikon
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.5 + (_bounceAnimation.value * 0.5),
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isWon
                                ? [AppColors.success, AppColors.success.withValues(alpha: 0.7)]
                                : [AppColors.failure, AppColors.failure.withValues(alpha: 0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isWon ? AppColors.success : AppColors.failure)
                                  .withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          isWon ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Başlık
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isWon
                            ? [AppColors.success, Colors.teal]
                            : [AppColors.failure, Colors.orange],
                      ).createShader(bounds),
                      child: Text(
                        isWon ? "TEBRİKLER!" : "SÜRE DOLDU!",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cevap
                    Text(
                      "Cevap: ${game.currentWord?.word}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.primaryDarkTheme : AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Puan kutusu
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - _bounceAnimation.value)),
                          child: Opacity(
                            opacity: _bounceAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isWon
                                ? [AppColors.accent, AppColors.accent.withValues(alpha: 0.8)]
                                : [AppColors.neutral, AppColors.neutralDark],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isWon ? Icons.star : Icons.star_border,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "+${isWon ? game.currentScore : 0} Puan",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Butonlar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: TextButton.icon(
                            onPressed: () =>
                                Navigator.popUntil(context, (route) => route.isFirst),
                            icon: Icon(
                              Icons.home,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.neutral,
                              size: 20,
                            ),
                            label: Text(
                              "ANA SAYFA",
                              style: TextStyle(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.neutral,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isWon ? AppColors.success : AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {
                              game.nextLevel();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const GamePage()),
                              );
                            },
                            icon: const Icon(Icons.play_arrow, size: 20),
                            label: const Text(
                              "DEVAM",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
