import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final int currentStep; // 1, 2, or 3
  final int subStep; // 0 to max
  final int maxSubStepsPerStep;

  const CustomProgressBar({
    super.key,
    required this.currentStep,
    required this.subStep,
    this.maxSubStepsPerStep = 11, // default to A–K
  });

  @override
  Widget build(BuildContext context) {
    final stepTitles = ["Account Creation", "Profiling Stage", "Risk Report"];
    final totalSteps = stepTitles.length;

    final double segmentWidthFraction = 1 / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;

            double totalGreenWidth = 0;
            for (int i = 1; i <= totalSteps; i++) {
              if (i < currentStep) {
                totalGreenWidth += totalWidth * segmentWidthFraction;
              } else if (i == currentStep) {
                final subProgress = subStep / maxSubStepsPerStep;
                totalGreenWidth += totalWidth * segmentWidthFraction * subProgress;
              }
            }

            return Stack(
              children: [
                // Full background bar
                Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                // Gray section for current step
                Positioned(
                  left: (currentStep - 1) * totalWidth * segmentWidthFraction,
                  child: Container(
                    height: 16,
                    width: totalWidth * segmentWidthFraction,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCCCCC),
                      borderRadius: BorderRadius.horizontal(
                        left: currentStep == 1 ? const Radius.circular(20) : Radius.zero,
                        right: currentStep == totalSteps ? const Radius.circular(20) : Radius.zero,
                      ),
                    ),
                  ),
                ),

                // Green fill (total progress)
                Container(
                  height: 16,
                  width: totalGreenWidth,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.horizontal(
                      left: const Radius.circular(20),
                      right: (currentStep == totalSteps && subStep == maxSubStepsPerStep)
                          ? const Radius.circular(20)
                          : Radius.zero,
                    ),
                  ),
                ),

                // Step label
                Positioned(
                  left: (currentStep - 1) * totalWidth * segmentWidthFraction,
                  width: totalWidth * segmentWidthFraction,
                  child: Center(
                    child: Text(
                      "$currentStep of $totalSteps",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Objective',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 360;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(stepTitles.length, (index) {
                final isActive = index == currentStep - 1;
                final titleParts = stepTitles[index].split(' ');

                return Expanded(
                  child: Center(
                    child: isSmallScreen && titleParts.length > 1
                        ? Column(
                            children: titleParts.map((part) {
                              return Text(
                                part,
                                style: TextStyle(
                                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                  color: isActive ? Colors.black : Colors.blueGrey,
                                  fontFamily: 'Objective',
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }).toList(),
                          )
                        : Text(
                            stepTitles[index],
                            style: TextStyle(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? Colors.black : Colors.blueGrey,
                              fontFamily: 'Objective',
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
