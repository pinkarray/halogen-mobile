import 'package:flutter/material.dart';
import 'bounce_tap.dart';

class TripOptionTile extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Widget? child;

  const TripOptionTile({
    super.key,
    required this.isSelected,
    required this.title,
    required this.description,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Objective',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isSelected ? Colors.black : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: const Color(0xFFE0E0E0), // subtle divider
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            if (isSelected && child != null) ...[
              const SizedBox(height: 16),
              child!
            ]
          ],
        ),
      ),
    );
  }
}