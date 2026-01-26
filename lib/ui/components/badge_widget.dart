import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/models/badge_model.dart';

class BadgeWidget extends StatelessWidget {
  final BadgeModel badge;
  final bool isLocked;
  final double size;

  const BadgeWidget({
    super.key,
    required this.badge,
    this.isLocked = false,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBadgeDetails(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.grey.shade300
                  : badge.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: isLocked ? Colors.grey : badge.color,
                width: 3,
              ),
              boxShadow: isLocked
                  ? null
                  : [
                      BoxShadow(
                        color: badge.color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Icon(
              isLocked ? Icons.lock : badge.icon,
              size: size * 0.5,
              color: isLocked ? Colors.grey : badge.color,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: size + 20,
            child: Text(
              badge.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isLocked ? Colors.grey : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.grey.shade200
                    : badge.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLocked ? Icons.lock : badge.icon,
                size: 48,
                color: isLocked ? Colors.grey : badge.color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badge.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isLocked ? Colors.grey : badge.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isLocked ? Colors.grey : AppColors.textDark,
              ),
            ),
            if (isLocked) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Kilitli',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}

class BadgeGrid extends StatelessWidget {
  final List<BadgeModel> unlockedBadges;
  final List<BadgeModel> lockedBadges;

  const BadgeGrid({
    super.key,
    required this.unlockedBadges,
    required this.lockedBadges,
  });

  @override
  Widget build(BuildContext context) {
    final allBadges = [
      ...unlockedBadges.map((b) => {'badge': b, 'locked': false}),
      ...lockedBadges.map((b) => {'badge': b, 'locked': true}),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
      ),
      itemCount: allBadges.length,
      itemBuilder: (context, index) {
        final item = allBadges[index];
        return BadgeWidget(
          badge: item['badge'] as BadgeModel,
          isLocked: item['locked'] as bool,
          size: 50,
        );
      },
    );
  }
}

class NewBadgeDialog extends StatelessWidget {
  final BadgeModel badge;

  const NewBadgeDialog({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.celebration,
            size: 48,
            color: AppColors.accent,
          ),
          const SizedBox(height: 16),
          const Text(
            'Yeni Rozet Kazandin!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: badge.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: badge.color, width: 3),
            ),
            child: Icon(
              badge.icon,
              size: 48,
              color: badge.color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: badge.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.neutral,
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: badge.color,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Harika!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
