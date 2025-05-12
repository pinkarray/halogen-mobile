import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/physical_security_progress_bar.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/glowing_arrows_button.dart';
import '../../../shared/widgets/bounce_tap.dart';
import 'location_confirmation_screen.dart';
import 'desired_services_screen.dart';
import 'providers/physical_security_provider.dart';

class PhysicalSecurityScreen extends StatefulWidget {
  const PhysicalSecurityScreen({super.key});

  @override
  State<PhysicalSecurityScreen> createState() => _PhysicalSecurityScreenState();
}

class _PhysicalSecurityScreenState extends State<PhysicalSecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final houseNumberController = TextEditingController();
  final streetNameController = TextEditingController();
  final areaController = TextEditingController();
  final stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PhysicalSecurityProvider>(context, listen: false);
    houseNumberController.text = provider.houseNumber;
    streetNameController.text = provider.streetName;
    areaController.text = provider.area;
    stateController.text = provider.state;
  }

  @override
  void dispose() {
    houseNumberController.dispose();
    streetNameController.dispose();
    areaController.dispose();
    stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhysicalSecurityProvider>(context);
    int currentStep = provider.addressConfirmed ? 2 : 1;
    if (currentStep > 6) currentStep = 6;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFFFAEA)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const HalogenBackButton(),
                    Expanded(
                      child: Text(
                        "Physical Security",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Objective',
                        ),
                      ).animate().fade(duration: 400.ms).slideY(begin: 0.3, end: 0),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),
                PhysicalSecurityProgressBar(currentStep: currentStep, progressContext: 'site'),
                const SizedBox(height: 24),
                const Text("Site Inspection", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Objective')),
                const SizedBox(height: 4),
                const Text("Pick a date and time convenient for you", style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabeled("Preferred Date", _buildDatePicker(context, provider)),
                      const SizedBox(height: 12),
                      _buildLabeled("Preferred Time", _buildTimePicker(context, provider)),
                      const SizedBox(height: 12),
                      _buildLabeled("House Number", _buildTextField(houseNumberController, 'houseNumber')),
                      const SizedBox(height: 12),
                      _buildLabeled("Street Name", _buildTextField(streetNameController, 'streetName')),
                      const SizedBox(height: 12),
                      _buildLabeled("Area", _buildTextField(areaController, 'area')),
                      const SizedBox(height: 12),
                      _buildLabeled("State", _buildTextField(stateController, 'state')),
                      const SizedBox(height: 12),
                      BounceTap(
                        onTap: () async {
                          final confirmed = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LocationConfirmationScreen()),
                          );
                          if (confirmed == true) {
                            provider.updateInspectionData(confirmed: true);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.location_pin, color: Colors.red),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                provider.addressConfirmed
                                    ? 'Address confirmed'
                                    : 'Input your address on the map for confirmation',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Objective',
                                  color: provider.addressConfirmed ? Colors.black : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      GlowingArrowsButton(
                        text: 'Send',
                        enabled: provider.isFormComplete,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DesiredServicesScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeled(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Objective',
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String fieldKey) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        final provider = context.read<PhysicalSecurityProvider>();
        switch (fieldKey) {
          case 'houseNumber':
            provider.updateInspectionData(houseNum: value.trim());
            break;
          case 'streetName':
            provider.updateInspectionData(street: value.trim());
            break;
          case 'area':
            provider.updateInspectionData(areaText: value.trim());
            break;
          case 'state':
            provider.updateInspectionData(stateText: value.trim());
            break;
        }
      },
      decoration: InputDecoration(
        hintText: 'Input here',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, PhysicalSecurityProvider provider) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          provider.updateInspectionData(date: picked);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: provider.preferredDate == null
                ? 'Pick your preferred date'
                : '${provider.preferredDate!.day}/${provider.preferredDate!.month}/${provider.preferredDate!.year}',
            suffixIcon: const Icon(Icons.calendar_today_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, PhysicalSecurityProvider provider) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          provider.updateInspectionData(time: picked);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: provider.preferredTime == null
                ? 'Pick your preferred time'
                : provider.preferredTime!.format(context),
            suffixIcon: const Icon(Icons.access_time_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}
