import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPress;
  final Set<String> disabledKeys;

  const CustomKeyboard({
    super.key,
    required this.onKeyPress,
    required this.disabledKeys,
  });

  final String _keys = "ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        runSpacing: 6,
        children: _keys.split('').map((char) {
          final isDisabled = disabledKeys.contains(char);
          return SizedBox(
            width: 36,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: isDisabled
                    ? AppColors.neutral
                    : AppColors.primary,
                elevation: isDisabled ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isDisabled ? null : () => onKeyPress(char),
              child: Text(
                char,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
