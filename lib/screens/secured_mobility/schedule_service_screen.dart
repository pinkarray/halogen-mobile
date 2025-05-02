import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_form_data_provider.dart';
import '../../../widgets/halogen_back_button.dart';
import '../../../utils/pricing_config.dart';

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
    final data = context.read<UserFormDataProvider>()
        .allSections['secured_mobility']?['schedule_service'] ?? {};

    _pickupController.text = data['pickup_location'] ?? '';
    _dropoffController.text = data['dropoff_location'] ?? '';
    if (data['pickup_date'] != null) {
      _selectedDate = DateTime.parse(data['pickup_date']);
    }
    if (data['pickup_time'] != null) {
      final parts = (data['pickup_time'] as String).split(':');
      _selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
  }

  void _saveDataAndContinue() {
    final provider = context.read<UserFormDataProvider>();
    final existing = Map<String, dynamic>.from(
      provider.allSections['secured_mobility'] ?? {},
    );

    // ✅ 1. Save schedule form data
    existing['schedule_service'] = {
      'pickup_location': _pickupController.text,
      'dropoff_location': _dropoffController.text,
      'pickup_date': _selectedDate?.toIso8601String(),
      'pickup_time': _selectedTime != null
          ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
          : null,
    };

    // ✅ 2. Pull other form values for pricing
    final desiredServices = existing['desired_services'];
    final serviceConfig = existing['service_configuration'];

    int total = 0;

    // 🟢 Add trip type price (Step 1)
    final tripType = desiredServices?['trip_type'];
    if (tripType != null) {
      total += pricingMap['desired_services']?[tripType] ?? 0;
    }

    // 🟨 Add service config prices (Step 2)
    if (serviceConfig != null) {
      for (final section in ['vehicle_choice', 'pilot_vehicle', 'in_car_protection']) {
        final sectionData = serviceConfig[section];
        if (sectionData?['enabled'] == true) {
          final selected = sectionData['selection'];
          total += pricingMap[section]?[selected] ?? 0;
        }
      }
    }

    // ✅ 3. Save total cost to provider
    existing['total_cost'] = total;

    provider.updateSection('secured_mobility', existing);
    provider.updateMobilityStage(4);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: double.infinity,
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            HalogenBackButton(),
                            SizedBox(width: 12),
                            Text(
                              'Schedule Service',
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
                          'Pick Up & Drop Off (One way)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Objective',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pick up location', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _pickupController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter location',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text('Drop off location', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _dropoffController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter location',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text('Pick up date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    hintText: 'Pick your preferred date',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
                                  ),
                                  child: Text(
                                    _selectedDate != null
                                        ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                                        : '',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text('Pick up time', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: _selectedTime ?? TimeOfDay.now(),
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _selectedTime = time;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    hintText: 'Pick your preferred time',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.access_time, color: Colors.black),
                                  ),
                                  child: Text(
                                    _selectedTime != null
                                        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                        : '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            ),
                            onPressed: _saveDataAndContinue,
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
            ),
          );
        },
      ),
    );
  }
}
