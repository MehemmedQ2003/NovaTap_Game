import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AvatarSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const AvatarSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avatar Sec',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppAvatars.all.length,
            itemBuilder: (context, index) {
              final avatar = AppAvatars.all[index];
              final isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () => onSelected(index),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? avatar.color.withValues(alpha: 0.2) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? avatar.color : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        avatar.icon,
                        size: 32,
                        color: avatar.color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        avatar.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: avatar.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AvatarWidget extends StatelessWidget {
  final int avatarIndex;
  final double size;
  final bool showBorder;

  const AvatarWidget({
    super.key,
    required this.avatarIndex,
    this.size = 40,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = AppAvatars.get(avatarIndex);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatar.color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: avatar.color, width: 2)
            : null,
      ),
      child: Icon(
        avatar.icon,
        size: size * 0.5,
        color: avatar.color,
      ),
    );
  }
}
