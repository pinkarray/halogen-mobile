import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/secured_mobility_progress_bar.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import './providers/secured_mobility_provider.dart';

class SecuredMobilityScreen extends StatefulWidget {
  const SecuredMobilityScreen({super.key});

  @override
  State<SecuredMobilityScreen> createState() => _SecuredMobilityScreenState();
}

class _SecuredMobilityScreenState extends State<SecuredMobilityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
            child: Consumer<SecuredMobilityProvider>(
              builder: (context, provider, _) {
                final currentStage = provider.currentStage;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        HalogenBackButton(),
                        SizedBox(width: 12),
                        Text(
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
                    _buildTile(context, currentStage, icon: Icons.directions_car, label: 'Desired Services', stageNumber: 1, route: '/secured-mobility/desired-services'),
                    _buildTile(context, currentStage, icon: Icons.settings, label: 'Service Configuration', stageNumber: 2, route: '/secured-mobility/service-configuration'),
                    _buildTile(context, currentStage, icon: Icons.calendar_today, label: 'Schedule Service', stageNumber: 3, route: '/secured-mobility/schedule-service'),
                    _buildTile(context, currentStage, icon: Icons.receipt_long, label: 'Confirm Order / Order Summary', stageNumber: 4, route: '/secured-mobility/summary'),
                    _buildTile(context, currentStage, icon: Icons.payment, label: 'Payment', stageNumber: 5, route: '/secured-mobility/payment'),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    int currentStage, {
    required IconData icon,
    required String label,
    required int stageNumber,
    required String route,
  }) {
    final isCompleted = currentStage > stageNumber;
    final isActive = currentStage == stageNumber;
    final isUnlocked = currentStage >= stageNumber;

    return BounceTap(
      onTap: () {
        if (isUnlocked) {
          Navigator.pushNamed(context, route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please complete Stage ${stageNumber - 1} first.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.5,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.5 * 255).round()),
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
      ),
    );
  }
}
