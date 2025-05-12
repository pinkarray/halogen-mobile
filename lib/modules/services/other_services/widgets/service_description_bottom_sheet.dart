import 'package:flutter/material.dart';
import '../../../../shared/widgets/bounce_tap.dart';
import '../contact_options_screen.dart';

class ServiceDescriptionBottomSheet extends StatelessWidget {
  final String title;
  final String description;

  const ServiceDescriptionBottomSheet({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  void _goToContactOptions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ContactOptionsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.close, size: 16),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Objective',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Objective',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            BounceTap(
              onTap: () => _goToContactOptions(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2B66),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.mail, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Contact us',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Objective',
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios,
                        size: 12, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
