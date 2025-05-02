import 'package:flutter/material.dart';

class OutsourcingProgressBar extends StatelessWidget {
  final int currentStep;
  final double stage1ProgressPercent;
  final bool stage2Completed;
  final bool stage3Completed;

  const OutsourcingProgressBar({
    super.key,
    required this.currentStep,
    this.stage1ProgressPercent = 0.0,
    this.stage2Completed = false,
    this.stage3Completed = false,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFBDBDBD);
    const inactiveColor = Color(0xFFE0E0E0);
    const green = Colors.green;
    final labels = ['Stage 1', 'Stage 2', 'Stage 3'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Top Bar
        Row(
          children: List.generate(3, (index) {
            if (index == 0) {
              return Expanded(
                child: Stack(
                  children: [
                    // Background gray
                    Container(
                      height: 6,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: inactiveColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // Animated green foreground for Stage 1
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: stage1ProgressPercent),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, _) {
                        return Container(
                          width: MediaQuery.of(context).size.width * (value / 3),
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            // ✅ Stage 2 and Stage 3 logic
            final isStageCompleted = (index == 1 && stage2Completed) || (index == 2 && stage3Completed);
            final isCompleted = index < currentStep - 1;
            final isActive = index == currentStep - 1;

            Color color = inactiveColor;
            if (isStageCompleted || isCompleted) {
              color = green;
            } else if (isActive) {
              color = activeColor;
            }

            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        // ✅ Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) {
            final isStageCompleted = (index == 1 && stage2Completed) || (index == 2 && stage3Completed);
            final isCompleted = index < currentStep - 1;
            final isActive = index == currentStep - 1;

            return Expanded(
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Objective',
                    color: isStageCompleted || isCompleted
                        ? green
                        : isActive
                            ? Colors.black
                            : Colors.grey.shade400,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
