import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_form_data_provider.dart';

class ResidenceTypeScreen extends StatefulWidget {
  const ResidenceTypeScreen({super.key});

  @override
  State<ResidenceTypeScreen> createState() => _ResidenceTypeScreenState();
}

class _ResidenceTypeScreenState extends State<ResidenceTypeScreen> {
  String? houseType;
  String? entranceType;

  final List<String> houseOptions = [
    "Detached",
    "Terrace",
    "Semi duplex",
    "Row of terrace",
    "Apartments"
  ];

  final List<String> entranceOptions = [
    "Gated estate",
    "Gated street",
    "Non-gated"
  ];

  @override
  void initState() {
    super.initState();

    final saved = Provider.of<UserFormDataProvider>(context, listen: false).allSections["E"];
    if (saved != null) {
      houseType = saved["houseType"];
      entranceType = saved["entranceType"];
    }
  }

  void _save() {
    final data = {
      "houseType": houseType,
      "entranceType": entranceType,
    };

    Provider.of<UserFormDataProvider>(context, listen: false).updateSection("E", data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Type of Residence",
          style: TextStyle(fontFamily: 'Objective', color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            _buildDropdown("Type of house", houseType, houseOptions, (val) {
              setState(() => houseType = val);
              _save();
            }),
            _buildDropdown("Residence entrance type", entranceType, entranceOptions, (val) {
              setState(() => entranceType = val);
              _save();
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Save & Continue", style: TextStyle(color: Colors.white, fontFamily: 'Objective')),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> options, ValueChanged<String?>? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: options.contains(value) ? value : null,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Objective'),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option, style: const TextStyle(fontFamily: 'Objective')),
          );
        }).toList(),
      ),
    );
  }
}
