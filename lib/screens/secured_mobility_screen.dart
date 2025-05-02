import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_form_data_provider.dart';
import '../widgets/secured_mobility_progress_bar.dart';
import '../widgets/bounce_tap.dart';
import '../widgets/halogen_back_button.dart';

class SecuredMobilityScreen extends StatelessWidget {
  const SecuredMobilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentStage = context.watch<UserFormDataProvider>().getCurrentMobilityStage();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const HalogenBackButton(),
                  const SizedBox(width: 12),
                  const Text(
                    'Secured Mobility',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Objective',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SecuredMobilityProgressBar(currentStep: currentStage),
              const SizedBox(height: 24),
              _buildTile(
                context,
                icon: Icons.directions_car,
                label: 'Desired Services',
                stageNumber: 1,
                onTap: () => Navigator.pushNamed(context, '/secured-mobility/desired-services'),
              ),
              _buildTile(
                context,
                icon: Icons.settings,
                label: 'Service Configuration',
                stageNumber: 2,
                onTap: () => Navigator.pushNamed(context, '/secured-mobility/service-configuration'),
              ),
              _buildTile(
                context,
                icon: Icons.calendar_today,
                label: 'Schedule Service',
                stageNumber: 3,
                onTap: () => Navigator.pushNamed(context, '/secured-mobility/schedule-service'),
              ),
              _buildTile(
                context,
                icon: Icons.receipt_long,
                label: 'Confirm Order / Order Summary',
                stageNumber: 4,
                onTap: () => Navigator.pushNamed(context, '/secured-mobility/summary'),
              ),
              _buildTile(
                context,
                icon: Icons.payment,
                label: 'Payment',
                stageNumber: 5,
                onTap: () => Navigator.pushNamed(context, '/secured-mobility/payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required int stageNumber,
  }) {
    final currentStage = context.watch<UserFormDataProvider>().getCurrentMobilityStage();
    final isCompleted = currentStage > stageNumber;
    final isActive = currentStage == stageNumber;

    return BounceTap(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
          children: [
            Icon(icon, color: Colors.black54, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontFamily: 'Objective',
                ),
              ),
            ),
            if (isCompleted)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}
