import 'package:flutter/material.dart';

class PhysicalSecurityProgressBar extends StatelessWidget {
  final int currentStep; // from 1 to 6
  final String progressContext; // 'site', 'services', 'result'
  final int totalSteps = 6;

  const PhysicalSecurityProgressBar({
    super.key,
    required this.currentStep,
    required this.progressContext,
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
            final section2Progress = (currentStep - 1).clamp(0, 5) / 5;
            final section2GreenWidth = sectionWidth * section2Progress;

            return Stack(
              children: [
                // Light gray background
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                // Section 1: Site Inspection
                Positioned(
                  left: 0,
                  child: Container(
                    height: 24,
                    width: sectionWidth,
                    decoration: BoxDecoration(
                      color: progressContext == 'site'
                          ? const Color(0xFFBDBDBD)
                          : Colors.green,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: progressContext != 'site'
                        ? const Center(
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
                          )
                        : null,
                  ),
                ),

                // Section 2: Base (dark gray bar)
                Positioned(
                  left: sectionWidth,
                  child: Container(
                    height: 24,
                    width: sectionWidth,
                    color: (progressContext == 'services' || progressContext == 'result')
                        ? const Color(0xFFBDBDBD)
                        : const Color(0xFFEAEAEA),
                  ),
                ),

                // Section 2: Animated Green Growth
                if (progressContext == 'services')
                  Positioned(
                    left: sectionWidth,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 24,
                      width: section2GreenWidth,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: section2Progress >= 1
                            ? BorderRadius.zero
                            : const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                      ),
                    ),
                  ),

                // Section 2: Desired Services Completed
                if (currentStep >= 6)
                  Positioned(
                    left: sectionWidth,
                    child: Container(
                      height: 24,
                      width: sectionWidth,
                      decoration: const BoxDecoration(color: Colors.green),
                      child: const Center(
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
                      ),
                    ),
                  ),


                // Section 3: Result
                Positioned(
                  left: sectionWidth * 2,
                  child: Container(
                    height: 24,
                    width: sectionWidth,
                    decoration: BoxDecoration(
                      color: progressContext == 'result'
                          ? const Color(0xFFBDBDBD)
                          : const Color(0xFFEAEAEA),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),

                // Dividers
                Positioned(left: sectionWidth, child: Container(height: 24, width: 2, color: Colors.white)),
                Positioned(left: sectionWidth * 2, child: Container(height: 24, width: 2, color: Colors.white)),

                // Step label
                if (currentStep < totalSteps)
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        '$currentStep of $totalSteps',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Objective',
                        ),
                      ),
                    ),
                  ),
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
                  "Site Inspection",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Objective',
                    color: Color.fromARGB(255, 50, 66, 50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Desired Services",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Objective',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Result",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Objective',
                    color: Colors.grey,
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
