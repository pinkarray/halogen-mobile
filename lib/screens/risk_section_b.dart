import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_form_data_provider.dart';

class SpouseProfileScreen extends StatefulWidget {
  const SpouseProfileScreen({super.key});

  @override
  State<SpouseProfileScreen> createState() => _SpouseProfileScreenState();
}

class _SpouseProfileScreenState extends State<SpouseProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form values
  String? title;
  String? gender;
  String? ageRange;
  String? maritalStatus;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final List<String> titleOptions = ["Ms.", "Mr", "Mrs"];
  final List<String> genderOptions = ["Male", "Female"];
  final List<String> ageRangeOptions = [
    "20 - 30",
    "31 - 40",
    "41 - 50",
    "51 - 60",
    "61 - 70",
    "71 - 80",
    "81 - 90",
    "91 - 100"
  ];
  final List<String> maritalOptions = ["Single", "Married"];

  @override
  void initState() {
    super.initState();

    final data = Provider.of<UserFormDataProvider>(context, listen: false).allSections["B"];
    if (data != null) {
      title = data["title"];
      firstNameController.text = data["firstName"] ?? '';
      lastNameController.text = data["lastName"] ?? '';
      gender = data["gender"];
      ageRange = data["ageRange"];
      maritalStatus = data["maritalStatus"];
    }

    firstNameController.addListener(_saveProgress);
    lastNameController.addListener(_saveProgress);
  }

  void _saveProgress() {
    final userData = {
      "title": title,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "gender": gender,
      "ageRange": ageRange,
      "maritalStatus": maritalStatus,
    };

    Provider.of<UserFormDataProvider>(context, listen: false)
        .updateSection("B", userData);
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
          "Spouse Profile",
          style: TextStyle(
            fontFamily: 'Objective',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              _buildDropdownField("Title", title, titleOptions, (value) {
                setState(() => title = value);
                _saveProgress();
              }),
              _buildTextField("First name", firstNameController),
              _buildTextField("Last name", lastNameController),
              _buildDropdownField("Gender", gender, genderOptions, (value) {
                setState(() => gender = value);
                _saveProgress();
              }),
              _buildDropdownField("Age range", ageRange, ageRangeOptions, (value) {
                setState(() => ageRange = value);
                _saveProgress();
              }),
              _buildDropdownField("Marital status", maritalStatus, maritalOptions, (value) {
                setState(() => maritalStatus = value);
                _saveProgress();
              }),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context), // optional, everything's already saved
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Save & Continue",
                  style: TextStyle(
                    fontFamily: 'Objective',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> options,
    ValueChanged<String?>? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
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
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        onChanged: (_) => _saveProgress(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Objective'),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }
}
