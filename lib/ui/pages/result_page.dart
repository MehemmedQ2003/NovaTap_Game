import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../../core/constants.dart';
import '../../logic/game_provider.dart';
import '../../logic/auth_provider.dart';
import 'quiz_page.dart';

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
  bool _scoreSaved = false;

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

    final game = context.read<GameProvider>();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      _scaleController.forward();
      _bounceController.forward();

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

    // Save score once
    if (!_scoreSaved) {
      _scoreSaved = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        game.saveScore(
          auth.currentUser?.name ?? "Misafir",
          auth.currentUser?.avatarIndex ?? 0,
        );
      });
    }

    return Scaffold(
      backgroundColor: isWon
          ? (isDark ? const Color(0xFF1B3D2F) : AppColors.success)
          : (isDark ? const Color(0xFF3D1B1B) : AppColors.failure),
      body: Stack(
        children: [
          // Confetti widgets
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
              colors: const [Colors.amber, Colors.cyan, Colors.lime, Colors.indigo],
            ),
          ),
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
              colors: const [Colors.teal, Colors.deepOrange, Colors.lightBlue, Colors.pinkAccent],
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
                        isWon ? "TEBRİKLER!" : "OYUN BİTTİ",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // İstatistikler
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatCard(
                          icon: Icons.check_circle,
                          value: "${game.correctAnswers}",
                          label: "Doğru",
                          color: AppColors.success,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 16),
                        _StatCard(
                          icon: Icons.cancel,
                          value: "${game.wrongAnswers}",
                          label: "Yanlış",
                          color: AppColors.failure,
                          isDark: isDark,
                        ),
                      ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0.8)],
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
                            const Icon(Icons.star, color: Colors.white, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              "${game.currentScore} Puan",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
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
                              backgroundColor: AppColors.primary,
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
                              game.initGame(
                                mode: game.gameMode,
                                difficulty: game.difficulty,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const QuizPage()),
                              );
                            },
                            icon: const Icon(Icons.replay, size: 20),
                            label: const Text(
                              "YENİDEN",
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }
}
