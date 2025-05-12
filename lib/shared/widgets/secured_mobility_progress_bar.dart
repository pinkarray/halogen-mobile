import 'package:flutter/material.dart';

class SecuredMobilityProgressBar extends StatelessWidget {
  final int currentStep; // 1-based index: 1 to 5

  const SecuredMobilityProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final List<String> labels = [
      'Stage 1',
      'Stage 2',
      'Stage 3',
      'Stage 4',
      'Stage 5',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final segmentWidth = (totalWidth - 8 * 4) / 5; // 4 gaps between 5 bars

            return Row(
              children: List.generate(5, (index) {
                final isCompleted = index < currentStep - 1;
                final isActive = index == currentStep - 1;

                Color color;
                if (isCompleted) {
                  color = Colors.green;
                } else if (isActive) {
                  color = const Color(0xFFBDBDBD);
                } else {
                  color = const Color(0xFFEAEAEA);
                }

                return Container(
                  width: segmentWidth,
                  height: 32,
                  margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.horizontal(
                      left: index == 0 ? const Radius.circular(30) : Radius.zero,
                      right: index == 4 ? const Radius.circular(30) : Radius.zero,
                    ),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                        final scale = CurvedAnimation(parent: animation, curve: Curves.decelerate);
                        return ScaleTransition(
                          scale: scale,
                          child: FadeTransition(opacity: fade, child: child),
                        );
                      },
                      child: isCompleted
                          ? Container(
                              key: const ValueKey('check'),
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 16,
                                ),
                              ),
                            )
                          : Text(
                              '${index + 1}',
                              key: ValueKey('step-${index + 1}'),
                              style: TextStyle(
                                fontFamily: 'Objective',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isActive ? Colors.white : Colors.black,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final isCompleted = index < currentStep - 1;
            final isActive = index == currentStep - 1;

            Color color;
            FontWeight weight;

            if (isCompleted) {
              color = Colors.green;
              weight = FontWeight.w600;
            } else if (isActive) {
              color = Colors.black;
              weight = FontWeight.bold;
            } else {
              color = Colors.grey.shade400;
              weight = FontWeight.w600;
            }

            return Expanded(
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontFamily: 'Objective',
                    fontSize: 12,
                    fontWeight: weight,
                    color: color,
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
