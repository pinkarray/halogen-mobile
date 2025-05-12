import 'package:flutter/material.dart';
import '../../../shared/widgets/glowing_arrows_button.dart'; // Make sure this path matches your project

class ContinueRegistrationPrompt extends StatelessWidget {
  final VoidCallback onContinue;

  const ContinueRegistrationPrompt({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Please complete your registration to view personalized recommendations.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontFamily: 'Objective',
          ),
        ),
        const SizedBox(height: 16),
        GlowingArrowsButton(
          text: "Continue Registration",
          onPressed: onContinue,
        ),
      ],
    );
  }
}
