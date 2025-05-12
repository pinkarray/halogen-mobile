import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  final String greetingText;
  final String subtitle;

  const GreetingHeader({
    super.key,
    this.greetingText = "Good morning",
    this.subtitle = "Your security is in check",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greetingText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Objective',
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
                fontFamily: 'Objective',
              ),
            ),
          ],
        ),
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/avatar.jpeg'),
            ),
            const SizedBox(width: 8),
            Stack(
              alignment: Alignment.topRight,
              children: const [
                Icon(Icons.notifications_none, size: 28),
                Positioned(
                  right: 0,
                  child: CircleAvatar(radius: 5, backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}