import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../data/models/word_model.dart';
import '../../logic/game_provider.dart';
import '../../logic/auth_provider.dart'; // Eklendi
import 'game_page.dart';
import 'scoreboard_page.dart';
import 'welcome_page.dart'; // Eklendi

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Difficulty _selectedDifficulty = Difficulty.medium;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.currentUser?.name ?? "Misafir";

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Karşılama Mesajı
              Text(
                "Merhaba, $userName",
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 10),

              const Icon(Icons.mosque, size: 80, color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                "KELİME AVCISI",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // ... ZORLUK SEÇİMİ VE BUTONLAR AYNI KALACAK ...
              // (Buraya önceki kodundaki zorluk seçimi Container'ını ve butonları yapıştır)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Zorluk Seviyesi",
                      style: AppTextStyles.subHeading,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDiffButton(
                          "KOLAY",
                          Difficulty.easy,
                          Colors.green,
                        ),
                        _buildDiffButton(
                          "NORMAL",
                          Difficulty.medium,
                          Colors.blue,
                        ),
                        _buildDiffButton("ZOR", Difficulty.hard, Colors.red),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _buildMenuButton(context, "TEK OYUNCU", GameMode.single),
              const SizedBox(height: 15),
              _buildMenuButton(context, "ÇİFT OYUNCU", GameMode.multiplayer),
              const SizedBox(height: 15),

              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScoreboardPage()),
                ),
                icon: const Icon(Icons.leaderboard, color: AppColors.accent),
                label: const Text(
                  "Puan Tablosu",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _buildDiffButton ve _buildMenuButton metodları öncekiyle aynı kalacak
  Widget _buildDiffButton(String text, Difficulty diff, Color color) {
    bool isSelected = _selectedDifficulty == diff;
    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = diff),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, GameMode mode) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textDark,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          context.read<GameProvider>().initGame(
            mode: mode,
            difficulty: _selectedDifficulty,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GamePage()),
          );
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
