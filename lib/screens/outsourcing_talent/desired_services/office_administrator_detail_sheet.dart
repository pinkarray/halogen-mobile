import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';

class OfficeAdministratorDetailSheet extends StatefulWidget {
  final VoidCallback onSaved;

  const OfficeAdministratorDetailSheet({super.key, required this.onSaved});

  @override
  State<OfficeAdministratorDetailSheet> createState() => _OfficeAdministratorDetailSheetState();
}

class _OfficeAdministratorDetailSheetState extends State<OfficeAdministratorDetailSheet> {
  bool maleSelected = false;
  bool femaleSelected = false;
  int maleQuantity = 1;
  int femaleQuantity = 1;

  @override
  void initState() {
    super.initState();
    final data = context.read<UserFormDataProvider>()
        .allSections['outsourcing_talent']?['desired_services']?['business_staff']?['office_administrator'] ?? {};

    if (data.isNotEmpty) {
      if (data['male'] != null) {
        maleSelected = true;
        maleQuantity = data['male'];
      }
      if (data['female'] != null) {
        femaleSelected = true;
        femaleQuantity = data['female'];
      }
    }
  }

  void _saveSelection() {
    final provider = context.read<UserFormDataProvider>();
    final all = Map<String, dynamic>.from(provider.allSections['outsourcing_talent'] ?? {});
    final desired = Map<String, dynamic>.from(all['desired_services'] ?? {});
    final businessStaff = Map<String, dynamic>.from(desired['business_staff'] ?? {});

    final Map<String, dynamic> roleData = {};

    if (maleSelected) {
      roleData['male'] = maleQuantity;
    }
    if (femaleSelected) {
      roleData['female'] = femaleQuantity;
    }

    if (roleData.isNotEmpty) {
      businessStaff['office_administrator'] = roleData;
      businessStaff['completed'] = true;

      desired['business_staff'] = businessStaff;

      provider.updateSection('outsourcing_talent', {
        ...all,
        'desired_services': desired,
      });

      widget.onSaved();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one gender.')),
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
                  'Office Administrator',
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

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Gender',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Objective',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Gender Checkboxes with Quantity
            ...[
              {'label': 'Male', 'selected': maleSelected, 'quantity': maleQuantity},
              {'label': 'Female', 'selected': femaleSelected, 'quantity': femaleQuantity},
            ].map((genderOption) {
              final isMale = genderOption['label'] == 'Male';
              final selected = isMale ? maleSelected : femaleSelected;
              final quantity = isMale ? maleQuantity : femaleQuantity;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Checkbox(
                  value: selected,
                  onChanged: (val) {
                    setState(() {
                      if (isMale) {
                        maleSelected = val ?? false;
                      } else {
                        femaleSelected = val ?? false;
                      }
                    });
                  },
                  activeColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(genderOption['label'] as String, style: const TextStyle(fontSize: 14)),
                    if (selected)
                      DropdownButton<int>(
                        value: quantity,
                        borderRadius: BorderRadius.circular(8),
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        underline: const SizedBox(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              if (isMale) {
                                maleQuantity = val;
                              } else {
                                femaleQuantity = val;
                              }
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