import 'package:flutter/material.dart';
import '../../core/constants.dart';

class TimerWidget extends StatelessWidget {
  final int currentTime;
  final double percent;

  const TimerWidget({
    super.key,
    required this.currentTime,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    Color timerColor = percent > 0.3
        ? AppColors.timerNormal
        : AppColors.timerCritical;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: percent,
            strokeWidth: 6,
            backgroundColor: Colors.grey[300],
            color: timerColor,
          ),
        ),
        Text(
          "$currentTime",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: timerColor,
          ),
        ),
      ],
    );
  }
}
