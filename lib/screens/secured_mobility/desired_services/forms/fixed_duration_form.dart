import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';

class FixedDurationForm extends StatefulWidget {
  const FixedDurationForm({super.key});

  @override
  State<FixedDurationForm> createState() => _FixedDurationFormState();
}

class _FixedDurationFormState extends State<FixedDurationForm> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  String? numberOfDays;
  String? interstate;

  final List<String> dayOptions = ['1 day', '2 days', '3 days', '4 days', '5 days'];
  final List<String> interstateOptions = ['Yes', 'No'];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final data = provider.allSections['secured_mobility']?['desired_services'] ?? {};

    pickupController.text = data['pickup_address'] ?? '';
    dropoffController.text = data['dropoff_address'] ?? '';
    numberOfDays = data['number_of_days'];
    interstate = data['interstate_travel'];
  }

  void _save() {
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final existing = Map<String, dynamic>.from(
      provider.allSections['secured_mobility'] ?? {},
    );

    existing['desired_services'] = {
      ...existing['desired_services'] ?? {},
      'trip_type': 'Fixed Duration',
      'pickup_address': pickupController.text,
      'dropoff_address': dropoffController.text,
      'number_of_days': numberOfDays,
      'interstate_travel': interstate,
    };

    provider.updateSection('secured_mobility', existing);
  }

  @override
  Widget build(BuildContext context) {
    const inputDecoration = InputDecoration(
      labelStyle: TextStyle(color: Colors.black),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: pickupController,
          decoration: inputDecoration.copyWith(labelText: 'Pick up address'),
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: dropoffController,
          decoration: inputDecoration.copyWith(labelText: 'Drop off address'),
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: inputDecoration.copyWith(labelText: 'Number of Days'),
          value: numberOfDays,
          items: dayOptions.map((day) => DropdownMenuItem(value: day, child: Text(day))).toList(),
          onChanged: (value) {
            setState(() => numberOfDays = value);
            _save();
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: inputDecoration.copyWith(labelText: 'Interstate Travel?'),
          value: interstate,
          items: interstateOptions.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          onChanged: (value) {
            setState(() => interstate = value);
            _save();
          },
        ),
      ],
    );
  }
}