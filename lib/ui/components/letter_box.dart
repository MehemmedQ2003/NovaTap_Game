import 'package:flutter/material.dart';
import '../../core/constants.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  final bool isRevealed;

  const LetterBox({super.key, required this.letter, required this.isRevealed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(4),
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: isRevealed ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isRevealed ? AppColors.primary : AppColors.primaryDark.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4))
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        isRevealed ? letter : "",
        style: AppTextStyles.gameLetter.copyWith(
          color: isRevealed ? Colors.white : AppColors.textDark,
        ),
      ),
    );
  }
}