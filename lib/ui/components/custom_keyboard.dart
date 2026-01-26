import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPress;
  final Set<String> disabledKeys;
  final Set<String> eliminatedKeys;

  const CustomKeyboard({
    super.key,
    required this.onKeyPress,
    required this.disabledKeys,
    this.eliminatedKeys = const {},
  });

  final String _keys = "ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        runSpacing: 6,
        children: _keys.split('').map((char) {
          final isDisabled = disabledKeys.contains(char);
          final isEliminated = eliminatedKeys.contains(char);

          Color bgColor;
          if (isEliminated) {
            bgColor = AppColors.failure.withValues(alpha: 0.3);
          } else if (isDisabled) {
            bgColor = isDark ? AppColors.neutralDark : AppColors.neutral;
          } else {
            bgColor = isDark ? AppColors.primaryDarkTheme : AppColors.primary;
          }

          return SizedBox(
            width: 36,
            height: 46,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: bgColor,
                  elevation: isDisabled || isEliminated ? 0 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isDisabled ? null : () => onKeyPress(char),
                child: Text(
                  char,
                  style: TextStyle(
                    color: isEliminated
                        ? AppColors.failure
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: isEliminated ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
