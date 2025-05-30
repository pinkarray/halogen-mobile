import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/service_option_group.dart';
import '../../../shared/widgets/secured_mobility_progress_bar.dart';
import './providers/secured_mobility_provider.dart';

class SecuredMobilityServiceConfigurationScreen extends StatefulWidget {
  const SecuredMobilityServiceConfigurationScreen({super.key});

  @override
  State<SecuredMobilityServiceConfigurationScreen> createState() => _SecuredMobilityServiceConfigurationScreenState();
}

class _SecuredMobilityServiceConfigurationScreenState extends State<SecuredMobilityServiceConfigurationScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SecuredMobilityProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFFAEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    HalogenBackButton(),
                    SizedBox(width: 12),
                    Text(
                      'Service Configuration',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Objective',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SecuredMobilityProgressBar(
                  percent: provider.progressPercent,
                  currentStep: provider.currentStage,
                ),
                const SizedBox(height: 24),
                const ServiceOptionGroup(
                  title: 'Vehicle Choice',
                  sectionKey: 'vehicle_choice',
                  options: ['SUV', 'Sedan'],
                ),
                const SizedBox(height: 20),
                const ServiceOptionGroup(
                  title: 'Pilot Vehicle (Hilux)',
                  sectionKey: 'pilot_vehicle',
                  options: ['Yes', 'No'],
                ),
                const SizedBox(height: 20),
                const ServiceOptionGroup(
                  title: 'In Car Protection',
                  sectionKey: 'in_car_protection',
                  options: [
                    'Unarmed - Closed Protection Officer',
                    'Armed - LEA (Law Enforcement Agent)'
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
