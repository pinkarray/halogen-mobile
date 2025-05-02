import 'package:flutter/material.dart';

class SecuredMobilityProgressBar extends StatelessWidget {
  final int currentStep; // from 1 to 5

  const SecuredMobilityProgressBar({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> stages = [
      'Stage 1',
      'Stage 2',
      'Stage 3',
      'Stage 4',
      'Stage 5',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            final isCompleted = index < currentStep - 1;
            final isActive = index == currentStep - 1;

            Color barColor;
            if (isCompleted) {
              barColor = Colors.green;
            } else if (isActive) {
              barColor = const Color(0xFFBDBDBD); // dark grey
            } else {
              barColor = const Color(0xFFE0E0E0); // light grey
            }

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                height: 8,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final isCompleted = index < currentStep - 1;
            final isActive = index == currentStep - 1;

            Color textColor;
            FontWeight weight;

            if (isCompleted) {
              textColor = Colors.green;
              weight = FontWeight.w600;
            } else if (isActive) {
              textColor = Colors.black;
              weight = FontWeight.bold;
            } else {
              textColor = Colors.grey.shade400;
              weight = FontWeight.w600;
            }

            return Expanded(
              child: Center(
                child: Text(
                  stages[index],
                  style: TextStyle(
                    fontFamily: 'Objective',
                    fontSize: 12,
                    fontWeight: weight,
                    color: textColor,
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
