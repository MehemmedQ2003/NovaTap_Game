import 'package:flutter/material.dart';
import '../../core/constants.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  final bool isRevealed;

  const LetterBox({super.key, required this.letter, required this.isRevealed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(4),
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: isRevealed
            ? (isDark ? AppColors.primaryDarkTheme : AppColors.primary)
            : (isDark ? AppColors.cardBackgroundDark : Colors.white),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isRevealed
              ? (isDark ? AppColors.primaryDarkTheme : AppColors.primary)
              : (isDark
                  ? AppColors.primaryDarkTheme.withValues(alpha: 0.3)
                  : AppColors.primaryDark.withValues(alpha: 0.3)),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 4,
            offset: const Offset(0, 4),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        isRevealed ? letter : "",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isRevealed
              ? Colors.white
              : (isDark ? AppColors.textLight : AppColors.textDark),
        ),
      ),
    );
  }
}
