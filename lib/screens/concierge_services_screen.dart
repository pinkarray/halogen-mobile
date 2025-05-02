import 'package:flutter/material.dart';

class ConciergeServicesScreen extends StatelessWidget {
  const ConciergeServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concierge Services'),
      ),
      body: const Center(
        child: Text(
          'This is the Concierge Services screen.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
