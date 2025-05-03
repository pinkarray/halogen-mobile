import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_form_data_provider.dart';
import '../../../widgets/halogen_back_button.dart';
import '../../../widgets/outsourcing_progress_bar.dart';
import '../../../widgets/bounce_tap.dart';

class OutsourcingTalentScreen extends StatelessWidget {
  const OutsourcingTalentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserFormDataProvider>();

    return Scaffold(
      body: SafeArea(  // ← Fixes issue with screen being too close to top
        child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HalogenBackButton(),
                  const SizedBox(width: 12),
                  // Flexible allows the text to wrap if needed
                  Flexible(
                    child: Text(
                      'Outsourcing & Talent Risk Management',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Objective',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              OutsourcingProgressBar(
                currentStep: provider.getCurrentOutsourcingStage(),
                stage1ProgressPercent: provider.stage1ProgressPercent,
                stage2Completed: provider.stage2Completed,
                stage3Completed: provider.stage3Completed,
              ),

              const SizedBox(height: 24),

              _buildTile(
                context,
                'Desired Services',
                '/outsourcing-talent/desired-services',
                provider.stage1ProgressPercent >= 1.0,
              ),
              _buildTile(
                context,
                'Description of Need',
                '/outsourcing-talent/description',
                provider.stage2Completed,
              ),
              _buildTile(
                context,
                'Confirmation',
                '/outsourcing-talent/confirmation',
                provider.stage3Completed,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTile(BuildContext context, String label, String route, bool completed) {
    IconData icon;

    if (label == 'Desired Services') {
      icon = Icons.assignment_outlined;
    } else if (label == 'Description of Need') {
      icon = Icons.description_outlined;
    } else if (label == 'Confirmation') {
      icon = Icons.checklist_outlined;
    } else {
      icon = Icons.precision_manufacturing_outlined;
    }

    return BounceTap(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Objective',
                ),
              ),
            ),
            if (completed)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}