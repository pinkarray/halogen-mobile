import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_form_data_provider.dart';

class HomeAddressScreen extends StatefulWidget {
  const HomeAddressScreen({super.key});

  @override
  State<HomeAddressScreen> createState() => _HomeAddressScreenState();
}

class _HomeAddressScreenState extends State<HomeAddressScreen> {
  final houseController = TextEditingController();
  final street1Controller = TextEditingController();
  final street2Controller = TextEditingController();

  String? selectedState;
  String? selectedLGA;
  String? selectedArea;

  final List<String> mockStates = ["Lagos", "Abuja", "Oyo"];
  final Map<String, List<String>> lgaMap = {
    "Lagos": ["Ikeja", "Surulere", "Epe"],
    "Abuja": ["Garki", "Wuse"],
    "Oyo": ["Ibadan North", "Ibadan South"]
  };
  final Map<String, List<String>> areaMap = {
    "Ikeja": ["Allen", "Alausa"],
    "Surulere": ["Aguda", "Ojuelegba"],
    "Epe": ["Eredo", "Ejinrin"],
    "Garki": ["Area 1", "Area 2"],
    "Wuse": ["Zone 1", "Zone 6"],
    "Ibadan North": ["Sango", "Bodija"],
    "Ibadan South": ["Molete", "Ring Road"]
  };

  @override
  void initState() {
    super.initState();

    final saved = Provider.of<UserFormDataProvider>(context, listen: false).allSections["D"];
    if (saved != null) {
      houseController.text = saved["house"] ?? '';
      street1Controller.text = saved["street1"] ?? '';
      street2Controller.text = saved["street2"] ?? '';
      selectedState = saved["state"];
      selectedLGA = saved["lga"];
      selectedArea = saved["area"];
    }

    houseController.addListener(_saveProgress);
    street1Controller.addListener(_saveProgress);
    street2Controller.addListener(_saveProgress);
  }

  void _saveProgress() {
    final data = {
      "house": houseController.text,
      "street1": street1Controller.text,
      "street2": street2Controller.text,
      "state": selectedState,
      "lga": selectedLGA,
      "area": selectedArea,
    };

    Provider.of<UserFormDataProvider>(context, listen: false).updateSection("D", data);
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
          "Home Address",
          style: TextStyle(fontFamily: 'Objective', color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            _buildTextField("House", houseController),
            _buildTextField("Street name 1", street1Controller),
            _buildTextField("Street name 2", street2Controller),
            _buildDropdown("State", selectedState, mockStates, (val) {
              setState(() {
                selectedState = val;
                selectedLGA = null;
                selectedArea = null;
              });
              _saveProgress();
            }),
            if (selectedState != null)
              _buildDropdown("Local government area", selectedLGA, lgaMap[selectedState] ?? [], (val) {
                setState(() {
                  selectedLGA = val;
                  selectedArea = null;
                });
                _saveProgress();
              }),
            if (selectedLGA != null)
              _buildDropdown("Area", selectedArea, areaMap[selectedLGA] ?? [], (val) {
                setState(() => selectedArea = val);
                _saveProgress();
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Objective'),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
