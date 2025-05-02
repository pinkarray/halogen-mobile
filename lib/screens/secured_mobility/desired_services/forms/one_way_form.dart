import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';

class OneWayForm extends StatefulWidget {
  const OneWayForm({super.key});

  @override
  State<OneWayForm> createState() => _OneWayFormState();
}

class _OneWayFormState extends State<OneWayForm> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final data = provider.allSections['secured_mobility']?['desired_services'] ?? {};

    pickupController.text = data['pickup_address'] ?? '';
    dropoffController.text = data['dropoff_address'] ?? '';
  }

  void _save() {
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final existing = Map<String, dynamic>.from(
      provider.allSections['secured_mobility'] ?? {},
    );

    existing['desired_services'] = {
      ...existing['desired_services'] ?? {},
      'trip_type': 'One Way',
      'pickup_address': pickupController.text,
      'dropoff_address': dropoffController.text,
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
      ],
    );
  }
}
