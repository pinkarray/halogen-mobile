import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'call_agent_screen.dart';

class ContactOptionsScreen extends StatelessWidget {
  const ContactOptionsScreen({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@halogen.com',
      query: 'subject=Customer Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFFFFAEA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Contact us',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Objective',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Select your preferred mode of contacting our customer service agents',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Objective',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CallAgentScreen()),
                ),
                title: const Text('Call agent',
                    style: TextStyle(fontFamily: 'Objective')),
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: _launchEmail,
                title: const Text('Send a mail',
                    style: TextStyle(fontFamily: 'Objective')),
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}