import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';
import '../../../../widgets/glowing_arrows_button.dart';

class ReturnForm extends StatefulWidget {
  const ReturnForm({super.key});

  @override
  State<ReturnForm> createState() => _ReturnFormState();
}

class _ReturnFormState extends State<ReturnForm> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  final TextEditingController returnDropoffController = TextEditingController();
  bool returnSameAsPickup = false;
  bool _tappedReturn = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final data = provider.allSections['secured_mobility']?['desired_services'] ?? {};

    pickupController.text = data['pickup_address'] ?? '';
    dropoffController.text = data['dropoff_address'] ?? '';
    returnDropoffController.text = data['return_dropoff_address'] ?? '';
    returnSameAsPickup = data['return_same_as_pickup'] ?? false;

    if (returnSameAsPickup) {
      returnDropoffController.text = pickupController.text;
    }
  }

  void _save() {
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final existing = Map<String, dynamic>.from(
      provider.allSections['secured_mobility'] ?? {},
    );

    existing['desired_services'] = {
      ...existing['desired_services'] ?? {},
      'trip_type': 'Return',
      'pickup_address': pickupController.text,
      'dropoff_address': dropoffController.text,
      'return_dropoff_address': returnDropoffController.text,
      'return_same_as_pickup': returnSameAsPickup,
    };

    provider.updateSection('secured_mobility', existing);
  }

  void _handleReturnTap() {
    if (!_tappedReturn && !returnSameAsPickup) {
      setState(() => _tappedReturn = true);

      Future.delayed(const Duration(milliseconds: 200), () {
        showDialog(
          context: context,
          barrierDismissible: false, // optional: force user to press "Okay"
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: SizedBox(
              height: 200, // controlled height for visual balance
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Extra Cost Alert',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Objective',
                    ),
                  ),
                  const Text(
                    'Your return address is different from pick-up, which attracts extra charges.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, fontFamily: 'Objective'),
                  ),
                  GlowingArrowsButton(
                    text: 'Okay',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const baseDecoration = InputDecoration(
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
          decoration: baseDecoration.copyWith(labelText: 'Pick up address'),
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: dropoffController,
          decoration: baseDecoration.copyWith(labelText: 'Drop off address'),
          onChanged: (_) => _save(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.black,
              ),
              child: Checkbox(
                value: returnSameAsPickup,
                activeColor: Colors.black,
                onChanged: (val) {
                  setState(() {
                    returnSameAsPickup = val ?? false;
                    if (returnSameAsPickup) {
                      returnDropoffController.text = pickupController.text;
                    } else {
                      returnDropoffController.clear();
                    }
                  });
                  _save();
                },
              ),
            ),
            const Expanded(
              child: Text(
                'Drop off address is the same with first trip pick up address',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: returnDropoffController,
          enabled: !returnSameAsPickup,
          decoration: baseDecoration.copyWith(labelText: 'Return drop off address'),
          onTap: _handleReturnTap,
          onChanged: (_) => _save(),
        ),
      ],
    );
  }
}
