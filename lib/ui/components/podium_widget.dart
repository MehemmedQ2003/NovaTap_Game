import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/services/score_service.dart';
import 'avatar_selector.dart';

class PodiumWidget extends StatelessWidget {
  final List<ScoreEntry> topThree;

  const PodiumWidget({super.key, required this.topThree});

  @override
  Widget build(BuildContext context) {
    if (topThree.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          if (topThree.length > 1)
            _PodiumPlace(
              entry: topThree[1],
              place: 2,
              height: 80,
              color: AppColors.silver,
            )
          else
            const SizedBox(width: 100),

          const SizedBox(width: 8),

          // 1st place
          if (topThree.isNotEmpty)
            _PodiumPlace(
              entry: topThree[0],
              place: 1,
              height: 100,
              color: AppColors.gold,
            ),

          const SizedBox(width: 8),

          // 3rd place
          if (topThree.length > 2)
            _PodiumPlace(
              entry: topThree[2],
              place: 3,
              height: 60,
              color: AppColors.bronze,
            )
          else
            const SizedBox(width: 100),
        ],
      ),
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  final ScoreEntry entry;
  final int place;
  final double height;
  final Color color;

  const _PodiumPlace({
    required this.entry,
    required this.place,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown for 1st place
        if (place == 1)
          const Icon(Icons.emoji_events, color: AppColors.gold, size: 32),

        // Avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            AvatarWidget(
              avatarIndex: entry.avatarIndex,
              size: place == 1 ? 60 : 50,
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                '$place',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Name
        SizedBox(
          width: 100,
          child: Text(
            entry.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Score
        Text(
          '${entry.score} P',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        // Podium block
        Container(
          width: 100,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _getPlaceEmoji(place),
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
      ],
    );
  }

  String _getPlaceEmoji(int place) {
    switch (place) {
      case 1:
        return '1';
      case 2:
        return '2';
      case 3:
        return '3';
      default:
        return '$place';
    }
  }
}
