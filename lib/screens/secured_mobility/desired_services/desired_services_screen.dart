import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/halogen_back_button.dart';
import '../../../widgets/secured_mobility_progress_bar.dart';
import '../../../widgets/trip_option_tile.dart';
import '../../../providers/user_form_data_provider.dart';
import 'forms/one_way_form.dart';
import 'forms/return_form.dart';
import 'forms/fixed_duration_form.dart';

class SecuredMobilityDesiredServicesScreen extends StatefulWidget {
  const SecuredMobilityDesiredServicesScreen({super.key});

  @override
  State<SecuredMobilityDesiredServicesScreen> createState() => _SecuredMobilityDesiredServicesScreenState();
}

class _SecuredMobilityDesiredServicesScreenState extends State<SecuredMobilityDesiredServicesScreen> {
  String? selectedTrip;

  bool isTripSectionComplete() {
    final data = Provider.of<UserFormDataProvider>(context, listen: false)
        .allSections['secured_mobility']?['desired_services'];

    if (data == null || data['trip_type'] == null) return false;

    switch (data['trip_type']) {
      case 'One Way':
        return data['pickup_address']?.isNotEmpty == true &&
            data['dropoff_address']?.isNotEmpty == true;
      case 'Return':
        return data['pickup_address']?.isNotEmpty == true &&
            data['dropoff_address']?.isNotEmpty == true &&
            data['return_dropoff_address']?.isNotEmpty == true;
      case 'Fixed Duration':
        return data['pickup_address']?.isNotEmpty == true &&
            data['dropoff_address']?.isNotEmpty == true &&
            data['number_of_days'] != null &&
            data['interstate_travel'] != null;
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final data = provider.allSections['secured_mobility']?['desired_services'] ?? {};
    selectedTrip = data['trip_type'];
  }

  void handleSelect(String trip) {
    setState(() => selectedTrip = trip);
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final existing = Map<String, dynamic>.from(
      provider.allSections['secured_mobility'] ?? {},
    );
    existing['desired_services'] = {
      ...existing['desired_services'] ?? {},
      'trip_type': trip
    };
    provider.updateSection('secured_mobility', existing);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);

    // 🟢 Update global stage if trip section is complete and not already updated
    if (isTripSectionComplete() && provider.getCurrentMobilityStage() < 2) {
      provider.updateMobilityStage(2);
    }

    return Scaffold(
      body: SafeArea(
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
                    'Desired Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Objective',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SecuredMobilityProgressBar(
                currentStep: isTripSectionComplete() ? 2 : 1,
              ),
              const SizedBox(height: 24),
              TripOptionTile(
                isSelected: selectedTrip == 'One Way',
                title: 'Pick Up & Drop Off (One way)',
                description: 'Move from your starting point to your destination without a return trip.',
                onTap: () => handleSelect('One Way'),
                child: selectedTrip == 'One Way' ? const OneWayForm() : null,
              ),
              TripOptionTile(
                isSelected: selectedTrip == 'Return',
                title: 'Pick Up & Drop Off (Return)',
                description: 'Get picked up, dropped off, and returned to your destination.',
                onTap: () => handleSelect('Return'),
                child: selectedTrip == 'Return' ? const ReturnForm() : null,
              ),
              TripOptionTile(
                isSelected: selectedTrip == 'Fixed Duration',
                title: 'Fixed Duration',
                description: 'Use the service for a fixed time before returning to your original location.',
                onTap: () => handleSelect('Fixed Duration'),
                child: selectedTrip == 'Fixed Duration' ? const FixedDurationForm() : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
