import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../data/models/question_model.dart';
import '../../logic/game_provider.dart';
import '../../logic/auth_provider.dart';
import '../../logic/theme_provider.dart';
import '../components/avatar_selector.dart';
import 'quiz_page.dart';
import 'scoreboard_page.dart';
import 'profile_page.dart';
import 'support_page.dart';
import 'welcome_page.dart';

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
    final themeProvider = context.watch<ThemeProvider>();
    final user = auth.currentUser;
    final userName = user?.name ?? "Misafir";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SupportPage()),
          ),
        ),
        actions: [
          // Tema toggle - Ay/Güneş
          GestureDetector(
            onTap: () => themeProvider.toggleTheme(),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(isDark),
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // User Avatar
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  ),
                  child: AvatarWidget(
                    avatarIndex: user?.avatarIndex ?? 0,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 12),

                // Welcome Message
                Text(
                  "Merhaba, $userName",
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 20),

                const Icon(Icons.quiz, size: 60, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  "DİNİ BİLGİ YARIŞMASI",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Difficulty Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardBackgroundDark.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Zorluk Seviyesi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.primaryDarkTheme : AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDiffButton("KOLAY", Difficulty.easy, Colors.green, isDark),
                          _buildDiffButton("NORMAL", Difficulty.medium, Colors.blue, isDark),
                          _buildDiffButton("ZOR", Difficulty.hard, Colors.red, isDark),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Game Mode Buttons
                _buildMenuButton(context, "TEK OYUNCU", GameMode.single),
                const SizedBox(height: 15),
                _buildMenuButton(context, "CIFT OYUNCU", GameMode.multiplayer),

                const SizedBox(height: 30),

                // Quick Access Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildQuickButton(
                      icon: Icons.leaderboard,
                      label: "Skorlar",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ScoreboardPage()),
                      ),
                    ),
                    const SizedBox(width: 20),
                    _buildQuickButton(
                      icon: Icons.person,
                      label: "Profil",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      ),
                    ),
                    const SizedBox(width: 20),
                    _buildQuickButton(
                      icon: Icons.help_outline,
                      label: "Destek",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SupportPage()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiffButton(String text, Difficulty diff, Color color, bool isDark) {
    bool isSelected = _selectedDifficulty == diff;
    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = diff),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : (isDark ? AppColors.neutralDark : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8)]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : Colors.grey[600]),
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
            MaterialPageRoute(builder: (_) => const QuizPage()),
          );
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildQuickButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
