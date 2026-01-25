import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00695C);
  static const Color primaryDark = Color(0xFF004D40);
  static const Color accent = Color(0xFFFFD740);
  static const Color background = Color(0xFFE0F2F1);

  static const Color success = Color(0xFF2E7D32);
  static const Color failure = Color(0xFFC62828);

  static const Color neutral = Color(0xFF9E9E9E);

  static const Color timerNormal = Color(0xFF1976D2);
  static const Color timerCritical = Color(0xFFD32F2F);

  static const Color textDark = Color(0xFF263238);
  static const Color textLight = Color(0xFFFFFFFF);
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
