import 'package:flutter/material.dart';

class OutsourcingProgressBar extends StatelessWidget {
  final int currentStep;
  final double stage1ProgressPercent;
  final bool stage1Completed;
  final bool stage2Completed;
  final bool stage3Completed;

  const OutsourcingProgressBar({
    super.key,
    required this.currentStep,
    required this.stage1ProgressPercent,
    required this.stage1Completed,
    required this.stage2Completed,
    required this.stage3Completed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final sectionWidth = totalWidth / 3;

            Widget completedPill() {
              return const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'Objective',
                      ),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                // Background
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                // Stage 1 block
                Positioned(
                  left: 0,
                  child: Container(
                    height: 24,
                    width: sectionWidth,
                    decoration: BoxDecoration(
                      color: stage1Completed
                          ? Colors.green
                          : (currentStep == 1 ? const Color(0xFFBDBDBD) : const Color(0xFFE0E0E0)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: stage1Completed ? completedPill() : null,
                  ),
                ),

                // Stage 2 block
                Positioned(
                  left: sectionWidth,
                  child: Container(
                    height: 24,
                    width: sectionWidth,
                    color: stage2Completed
                        ? Colors.green
                        : (currentStep == 2 ? const Color(0xFFBDBDBD) : const Color(0xFFE0E0E0)),
                    child: stage2Completed ? completedPill() : null,
                  ),
                ),

                // Stage 3 block
                Positioned(
                  left: sectionWidth * 2,
                  child: Container(
                    height: 24,
                    width: sectionWidth,
                    decoration: BoxDecoration(
                      color: stage3Completed
                          ? Colors.green
                          : (currentStep == 3 ? const Color(0xFFBDBDBD) : const Color(0xFFE0E0E0)),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: stage3Completed ? completedPill() : null,
                  ),
                ),

                // Dividers
                Positioned(left: sectionWidth, child: Container(height: 24, width: 2, color: Colors.white)),
                Positioned(left: sectionWidth * 2, child: Container(height: 24, width: 2, color: Colors.white)),
              ],
            );
          },
        ),
        const SizedBox(height: 8),

        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Center(
                child: Text(
                  "Stage 1",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Objective',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Stage 2",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Objective',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Stage 3",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Objective',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}