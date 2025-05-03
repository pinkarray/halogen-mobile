import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/physical_security_progress_bar.dart';
import '../widgets/halogen_back_button.dart';
import '../widgets/glowing_arrows_button.dart';
import '../widgets/bounce_tap.dart';
import 'location_confirmation_screen.dart';
import 'desired_services_screen.dart';
import '../providers/user_form_data_provider.dart';

class PhysicalSecurityScreen extends StatefulWidget {
  const PhysicalSecurityScreen({super.key});

  @override
  State<PhysicalSecurityScreen> createState() => _PhysicalSecurityScreenState();
}

class _PhysicalSecurityScreenState extends State<PhysicalSecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final houseNumberController = TextEditingController();
  final streetNameController = TextEditingController();
  final areaController = TextEditingController();
  final stateController = TextEditingController();

  bool isAddressConfirmed = false;
  List<String> selectedServices = [];

  @override
  void initState() {
    super.initState();
    final siteData = Provider.of<UserFormDataProvider>(context, listen: false).allSections['site_inspection'];

    if (siteData != null) {
      selectedDate = siteData['preferred_date'] != null ? DateTime.tryParse(siteData['preferred_date']) : null;
      selectedTime = siteData['preferred_time'] != null ? _parseTimeOfDay(siteData['preferred_time']) : null;
      houseNumberController.text = siteData['house_number'] ?? '';
      streetNameController.text = siteData['street_name'] ?? '';
      areaController.text = siteData['area'] ?? '';
      stateController.text = siteData['state'] ?? '';
      isAddressConfirmed = siteData['address_confirmed'] ?? false;
    }
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    final dateTime = DateFormat.jm().parse(timeString);
    return TimeOfDay.fromDateTime(dateTime);
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
    int currentStep = 1;
    if (isAddressConfirmed) currentStep = 2;
    currentStep += selectedServices.length;
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
                PhysicalSecurityProgressBar(currentStep: 1, progressContext: 'site'),

                const SizedBox(height: 24),
                const Text("Site Inspection",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Objective')),
                const SizedBox(height: 4),
                const Text("Pick a date and time convenient for you",
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 16),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabeled("Preferred Date", _buildDatePicker(context)),
                      const SizedBox(height: 12),
                      _buildLabeled("Preferred Time", _buildTimePicker(context)),
                      const SizedBox(height: 12),
                      _buildLabeled("House Number", _buildTextField(houseNumberController, 'House number')),
                      const SizedBox(height: 12),
                      _buildLabeled("Street Name", _buildTextField(streetNameController, 'Street name')),
                      const SizedBox(height: 12),
                      _buildLabeled("Area", _buildTextField(areaController, 'Area')),
                      const SizedBox(height: 12),
                      _buildLabeled("State", _buildTextField(stateController, 'State')),

                      const SizedBox(height: 12),
                      BounceTap(
                        onTap: () async {
                          final confirmed = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LocationConfirmationScreen()),
                          );
                          if (confirmed == true) {
                            setState(() {
                              isAddressConfirmed = true;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.location_pin, color: Colors.red),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                isAddressConfirmed
                                    ? 'Address confirmed'
                                    : 'Input your address on the map for confirmation',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Objective',
                                  color: isAddressConfirmed ? Colors.black : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      GlowingArrowsButton(
                        text: 'Send',
                        enabled: isAddressConfirmed,
                        onPressed: () {
                          final provider = Provider.of<UserFormDataProvider>(context, listen: false);
                          provider.updateSection("site_inspection", {
                            'preferred_date': selectedDate?.toIso8601String(),
                            'preferred_time': selectedTime?.format(context),
                            'house_number': houseNumberController.text.trim(),
                            'street_name': streetNameController.text.trim(),
                            'area': areaController.text.trim(),
                            'state': stateController.text.trim(),
                            'address_confirmed': isAddressConfirmed,
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DesiredServicesScreen()),
                          );
                        },
                      )
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

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Input your $hint',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() => selectedDate = picked);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: selectedDate == null
                ? 'Pick your preferred date'
                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
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

  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() => selectedTime = picked);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: selectedTime == null
                ? 'Pick your preferred time'
                : selectedTime!.format(context),
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
