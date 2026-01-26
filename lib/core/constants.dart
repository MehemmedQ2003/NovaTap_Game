import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color primary = Color(0xFF5C6BC0);        // Indigo 400
  static const Color primaryDark = Color(0xFF3949AB);    // Indigo 600
  static const Color primaryLight = Color(0xFF7986CB);   // Indigo 300
  static const Color accent = Color(0xFFFFAB40);         // Orange accent
  static const Color background = Color(0xFFF5F7FA);     // Soft gray-blue
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color primaryDarkTheme = Color(0xFF7C8DDC);
  static const Color primaryDarkDarkTheme = Color(0xFF5C6BC0);
  static const Color backgroundDark = Color(0xFF121218);
  static const Color surfaceDark = Color(0xFF1E1E2A);
  static const Color cardBackgroundDark = Color(0xFF262636);

  static const Color success = Color(0xFF4CAF50);
  static const Color failure = Color(0xFFEF5350);

  static const Color neutral = Color(0xFF9E9E9E);
  static const Color neutralLight = Color(0xFFE0E0E0);
  static const Color neutralDark = Color(0xFF424242);

  static const Color timerNormal = Color(0xFF42A5F5);
  static const Color timerCritical = Color(0xFFEF5350);

  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textSecondaryDark = Color(0xFFB0B0C0);

  // Podium colors
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );

  static const TextStyle gameLetter = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle keyLetter = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
}

class AppAvatars {
  static const List<AvatarData> all = [
    AvatarData(icon: Icons.mosque, label: 'Cami', color: Color(0xFF5C6BC0)),
    AvatarData(icon: Icons.auto_stories, label: 'Kuran', color: Color(0xFF1565C0)),
    AvatarData(icon: Icons.brightness_2, label: 'Hilal', color: Color(0xFF6A1B9A)),
    AvatarData(icon: Icons.star, label: 'Yildiz', color: Color(0xFFFF8F00)),
    AvatarData(icon: Icons.favorite, label: 'Kalp', color: Color(0xFFC62828)),
    AvatarData(icon: Icons.local_florist, label: 'Cicek', color: Color(0xFF2E7D32)),
    AvatarData(icon: Icons.wb_sunny, label: 'Gunes', color: Color(0xFFEF6C00)),
    AvatarData(icon: Icons.nightlight_round, label: 'Ay', color: Color(0xFF5E35B1)),
  ];

  static AvatarData get(int index) {
    if (index >= 0 && index < all.length) {
      return all[index];
    }
    return all[0];
  }
}

class AvatarData {
  final IconData icon;
  final String label;
  final Color color;

  const AvatarData({
    required this.icon,
    required this.label,
    required this.color,
  });
}
