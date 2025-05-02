import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_form_data_provider.dart';
import '../../../widgets/halogen_back_button.dart';
import '../../../widgets/service_option_group.dart';

class SecuredMobilityServiceConfigurationScreen extends StatelessWidget {
  const SecuredMobilityServiceConfigurationScreen({super.key});

  bool isConfigurationComplete(BuildContext context) {
    final data = Provider.of<UserFormDataProvider>(context, listen: false)
        .allSections['secured_mobility']?['service_configuration'];

    if (data == null) return false;

    final keys = ['vehicle_choice', 'pilot_vehicle', 'in_car_protection'];
    for (final key in keys) {
      final item = data[key];
      if (item?['enabled'] == true && (item?['selection'] == null || item['selection'].toString().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);

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
                const Divider(color: Colors.transparent),
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
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    onPressed: () {
                      if (isConfigurationComplete(context)) {
                        provider.updateMobilityStage(3);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please complete all selected sections.')),
                        );
                      }
                    },
                    child: const Text(
                      'Save & Continue',
                      style: TextStyle(fontSize: 16, fontFamily: 'Objective'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
