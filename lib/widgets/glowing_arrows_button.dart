import 'package:flutter/material.dart';
import 'glowing_arrows.dart'; // Make sure this import is correct

class GlowingArrowsButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  const GlowingArrowsButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Objective',
                ),
              ),
              const SizedBox(width: 8),
              const GlowingArrows(
                arrowColor: Colors.white,
                arrowSize: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
