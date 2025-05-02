import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';

class LeaLiaisonServicesBottomSheet extends StatefulWidget {
  const LeaLiaisonServicesBottomSheet({super.key});

  @override
  State<LeaLiaisonServicesBottomSheet> createState() => _LeaLiaisonServicesBottomSheetState();
}

class _LeaLiaisonServicesBottomSheetState extends State<LeaLiaisonServicesBottomSheet> {
  Map<String, bool> selectedOptions = {
    'police_liaison': false,
    'state_local_law_enforcement': false,
    'traffic': false,
  };
  Map<String, int> optionQuantities = {
    'police_liaison': 1,
    'state_local_law_enforcement': 1,
    'traffic': 1,
  };

  @override
  void initState() {
    super.initState();
    final data = context.read<UserFormDataProvider>()
        .allSections['outsourcing_talent']?['desired_services']?['lea_liaison'] ?? {};

    for (final key in selectedOptions.keys) {
      if (data[key] != null) {
        selectedOptions[key] = true;
        optionQuantities[key] = data[key];
      }
    }
  }

  void _saveSelection() {
    final provider = context.read<UserFormDataProvider>();
    final all = Map<String, dynamic>.from(provider.allSections['outsourcing_talent'] ?? {});
    final desired = Map<String, dynamic>.from(all['desired_services'] ?? {});

    final Map<String, dynamic> leaLiaison = {};

    selectedOptions.forEach((key, isSelected) {
      if (isSelected) {
        leaLiaison[key] = optionQuantities[key];
      }
    });

    if (leaLiaison.isNotEmpty) {
      leaLiaison['completed'] = true;
      desired['lea_liaison'] = leaLiaison;

      provider.updateSection('outsourcing_talent', {
        ...all,
        'desired_services': desired,
      });

      provider.calculateOutsourcingProgress(); // ✅ ADD THIS LINE

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one option.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(Icons.arrow_back, size: 18),
                Spacer(),
                Text(
                  'LEA Liaison Services',
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

            // ✅ Options with Checkbox + Quantity
            ...selectedOptions.keys.map((key) {
              final label = key.replaceAll('_', ' ').toUpperCase();
              final selected = selectedOptions[key] ?? false;
              final quantity = optionQuantities[key] ?? 1;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Checkbox(
                  value: selected,
                  onChanged: (val) {
                    setState(() {
                      selectedOptions[key] = val ?? false;
                    });
                  },
                  activeColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 14)),
                    if (selected)
                      DropdownButton<int>(
                        value: quantity,
                        borderRadius: BorderRadius.circular(8),
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        underline: const SizedBox(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              optionQuantities[key] = val;
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

            const SizedBox(height: 24),

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
      ),
    );
  }
}
