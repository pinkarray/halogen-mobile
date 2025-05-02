import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';

class HousekeeperDetailSheet extends StatefulWidget {
  final VoidCallback onSaved;

  const HousekeeperDetailSheet({super.key, required this.onSaved});

  @override
  State<HousekeeperDetailSheet> createState() => _HousekeeperDetailSheetState();
}

class _HousekeeperDetailSheetState extends State<HousekeeperDetailSheet> {
  String? selectedHousekeeperType;
  int selectedQuantity = 1;

  final housekeeperOptions = ['Full-time Housekeeper', 'Part-time Housekeeper'];

  @override
  void initState() {
    super.initState();

    final data = context.read<UserFormDataProvider>()
        .allSections['outsourcing_talent']?['desired_services']?['domestic_staff']?['housekeepers'] ?? {};

    selectedHousekeeperType = data['type'];
    selectedQuantity = data['quantity'] ?? 1;
  }

  void _saveSelection() {
    final provider = context.read<UserFormDataProvider>();
    final all = Map<String, dynamic>.from(
      provider.allSections['outsourcing_talent'] ?? {},
    );
    final desired = Map<String, dynamic>.from(all['desired_services'] ?? {});
    final domesticStaff = Map<String, dynamic>.from(
      desired['domestic_staff'] ?? {},
    );

    domesticStaff['housekeepers'] = {
      'type': selectedHousekeeperType,
      'quantity': selectedQuantity,
    };

    domesticStaff['completed'] = true;

    desired['domestic_staff'] = domesticStaff;

    provider.updateSection('outsourcing_talent', {
      ...all,
      'desired_services': desired,
    });

    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(Icons.arrow_back, size: 18),
              Spacer(),
              Text(
                'Housekeepers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Objective',
                ),
              ),
              Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          ...housekeeperOptions.map((label) {
            final isSelected = selectedHousekeeperType == label;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Radio<String>(
                value: label,
                groupValue: selectedHousekeeperType,
                onChanged: (val) {
                  setState(() {
                    selectedHousekeeperType = val;
                  });
                },
                activeColor: Colors.black,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14)),
                  if (isSelected)
                    DropdownButton<int>(
                      value: selectedQuantity,
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(8),
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            selectedQuantity = val;
                          });
                        }
                      },
                      items: [1, 2, 3]
                          .map((num) => DropdownMenuItem<int>(
                                value: num,
                                child: Text('$num'),
                              ))
                          .toList(),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _saveSelection,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}