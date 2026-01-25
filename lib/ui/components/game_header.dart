import 'package:flutter/material.dart';
import '../../core/constants.dart';

class GameHeader extends StatelessWidget {
  final int score;
  final int lives;

  const GameHeader({super.key, required this.score, required this.lives});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "SKOR",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text("$score", style: AppTextStyles.subHeading),
            ],
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < lives ? Icons.favorite : Icons.favorite_border,
                color: AppColors.failure,
                size: 28,
              );
            }),
          ),
        ],
      ),
    );
  }
}
