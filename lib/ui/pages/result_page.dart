import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../logic/game_provider.dart';
import '../../logic/auth_provider.dart';
import 'game_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameProvider>();
    final auth = context.read<AuthProvider>(); // Auth verisini al
    final isWon = game.status == GameStatus.won;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isWon) {
        // Şu anki kullanıcının adını göndererek kaydet
        game.saveScore(auth.currentUser?.name ?? "Misafir");
      }
    });

    return Scaffold(
      backgroundColor: isWon ? AppColors.success : AppColors.failure,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isWon ? Icons.stars : Icons.sentiment_very_dissatisfied,
                size: 80,
                color: isWon ? AppColors.success : AppColors.failure,
              ),
              const SizedBox(height: 20),
              Text(
                isWon ? "HARİKA!" : "SÜRE DOLDU!",
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 10),
              Text(
                "Cevap: ${game.currentWord?.word}",
                style: AppTextStyles.subHeading,
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Kazanılan Puan: +${isWon ? (game.currentScore) : 0}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text(
                      "ÇIKIŞ",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isWon
                          ? AppColors.success
                          : AppColors.failure,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      game.nextLevel();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const GamePage()),
                      );
                    },
                    child: const Text(
                      "DEVAM ET",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
