import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_form_data_provider.dart';
import '../../../widgets/halogen_back_button.dart';
import '../../../widgets/glowing_arrows_button.dart';

class DescriptionOfNeedScreen extends StatefulWidget {
  const DescriptionOfNeedScreen({super.key});

  @override
  State<DescriptionOfNeedScreen> createState() => _DescriptionOfNeedScreenState();
}

class _DescriptionOfNeedScreenState extends State<DescriptionOfNeedScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserFormDataProvider>();

    // ✅ Safely ensure outsourcing_talent is initialized
    final outsourcingData = Map<String, dynamic>.from(
      provider.allSections['outsourcing_talent'] ?? {},
    );

    final existingNeed = outsourcingData['description'] as String? ?? '';
    _controller.text = existingNeed;
  }

  void _saveAndContinue() {
    final provider = context.read<UserFormDataProvider>();

    // ✅ Ensure outsourcing_talent exists and cast it safely
    final outsourcingData = Map<String, dynamic>.from(
      provider.allSections['outsourcing_talent'] ?? {},
    );

    // ✅ Update the provider with the new description
    provider.updateSection('outsourcing_talent', {
      ...outsourcingData,
      'description': _controller.text.trim(),
    });

    provider.markStage2Completed(); // ✅ Move to stage 3
    Navigator.pushNamed(context, '/outsourcing-talent/confirmation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFFAEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                HalogenBackButton(),
                SizedBox(width: 12),
                Text(
                  'Description of Need',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Objective',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Explain your need',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Objective',
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'My need is.........',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Objective',
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: GlowingArrowsButton(
                text: 'Continue',
                onPressed: _saveAndContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}