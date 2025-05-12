import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallAgentScreen extends StatelessWidget {
  const CallAgentScreen({super.key});

  void _callNumber() async {
    final Uri telUri = Uri(scheme: 'tel', path: '09056546768');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      debugPrint('Could not launch phone dialer');
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
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.phone, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(
                      'Call 09056546768',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Objective',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _callNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C2B66),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Call',
                  style: TextStyle(fontFamily: 'Objective'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Objective',
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
