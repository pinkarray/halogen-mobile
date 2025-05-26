import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/underlined_glow_input_field.dart';
import '../../../shared/widgets/secured_mobility_progress_bar.dart';
import '../../../shared/widgets/underlined_glow_custom_date_picker.dart';
import '../../../shared/widgets/underlined_glow_custom_time_picker.dart';
import './providers/secured_mobility_provider.dart';

class ScheduleServiceScreen extends StatefulWidget {
  const ScheduleServiceScreen({super.key});

  @override
  State<ScheduleServiceScreen> createState() => _ScheduleServiceScreenState();
}

class _ScheduleServiceScreenState extends State<ScheduleServiceScreen> {
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    final provider = context.read<SecuredMobilityProvider>();
    _pickupController.text = provider.pickupLocation ?? '';
    _dropoffController.text = provider.dropoffLocation ?? '';
    _selectedDate = provider.pickupDate;
    _selectedTime = provider.pickupTime;

    _pickupController.addListener(_save);
    _dropoffController.addListener(_save);
  }

  void _save() {
    final provider = context.read<SecuredMobilityProvider>();
    provider.updateScheduleService(
      pickup: _pickupController.text,
      dropoff: _dropoffController.text,
      date: _selectedDate,
      time: _selectedTime,
    );

    if (provider.pickupLocation?.isNotEmpty == true &&
        provider.dropoffLocation?.isNotEmpty == true &&
        provider.pickupDate != null &&
        provider.pickupTime != null &&
        provider.currentStage < 4) {
      provider.markStageComplete(4);
      provider.calculateTotalCost();
    }
  }

  @override
  void dispose() {
    _pickupController.removeListener(_save);
    _dropoffController.removeListener(_save);
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SecuredMobilityProvider>();
    final clampedProgress = provider.progressPercent < 0.05 ? 0.0 : provider.progressPercent;

    return Scaffold(
      body: Stack(
        children: [
          // ✅ Full background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFFFFAEA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const HalogenBackButton(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Schedule Service',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Objective',
                            color: Color(0xFF1C2B66),
                          ),
                        ).animate().fade(duration: 600.ms).slideY(begin: 0.3, end: 0),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SecuredMobilityProgressBar(
                    percent: clampedProgress,
                    currentStep: 3,
                  ),
                  const SizedBox(height: 24),
                  // 🟨 Gradient-bordered form
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1C2B66), Color(0xFFFFCC29)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(2),
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UnderlinedGlowInputField(
                              label: 'Pick up location',
                              icon: Icons.location_on,
                              controller: _pickupController,
                              onChanged: (_) => _save(),
                            ),
                            const SizedBox(height: 16),
                            UnderlinedGlowInputField(
                              label: 'Drop off location',
                              icon: Icons.flag,
                              controller: _dropoffController,
                              onChanged: (_) => _save(),
                            ),
                            const SizedBox(height: 16),
                            UnderlinedGlowCustomDatePickerField(
                              label: 'Pick Up Date',
                              selectedDate: _selectedDate,
                              onConfirm: (date) {
                                setState(() => _selectedDate = date);
                                _save();
                              },
                            ),
                            const SizedBox(height: 16),
                            UnderlinedGlowCustomTimePickerField(
                              label: 'Pick Up Time',
                              selectedTime: _selectedTime,
                              onConfirm: (time) {
                                setState(() => _selectedTime = time);
                                _save();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}