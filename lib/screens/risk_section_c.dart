import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_form_data_provider.dart';

class ChildrenInfoScreen extends StatefulWidget {
  const ChildrenInfoScreen({super.key});

  @override
  State<ChildrenInfoScreen> createState() => _ChildrenInfoScreenState();
}

class _ChildrenInfoScreenState extends State<ChildrenInfoScreen> {
  int numberOfChildren = 0;
  bool sameSchool = false;
  List<String?> ageRanges = [];
  List<Map<String?, String?>> schoolDetails = [];

  final List<String> numberOptions = List.generate(10, (i) => "${i + 1}");
  final List<String> ageRangeOptions = [
    "0 - 10", "11 - 20", "21 - 30", "31 - 40", "41 - 50",
    "51 - 60", "61 - 70", "71 - 80", "81 - 90", "91 - 100"
  ];
  final List<String> schoolingOptions = ["Day", "Boarding"];

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
    final saved = Provider.of<UserFormDataProvider>(context, listen: false).allSections["C"];
    if (saved != null) {
      setState(() {
        numberOfChildren = int.tryParse(saved["numberOfChildren"] ?? "0") ?? 0;
        sameSchool = saved["sameSchool"] ?? false;

        ageRanges = List<String?>.from(saved["ageRanges"] ?? []);
        schoolDetails = List<Map<String?, String?>>.from(
            (saved["schoolDetails"] as List?)?.map((e) => Map<String?, String?>.from(e)) ?? []);
      });
    }
  }

  void updateSection() {
    Provider.of<UserFormDataProvider>(context, listen: false).updateSection("C", {
      "numberOfChildren": "$numberOfChildren",
      "sameSchool": sameSchool,
      "ageRanges": ageRanges,
      "schoolDetails": schoolDetails,
    });
  }

  void onNumChildrenChanged(String? selected) {
    final newCount = int.tryParse(selected ?? "") ?? 0;

    setState(() {
      numberOfChildren = newCount;
      ageRanges = List.filled(newCount, null);
      schoolDetails = List.generate(newCount, (_) => {
        "schoolingType": null,
        "state": null,
        "lga": null,
        "area": null,
      });
    });

    updateSection();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Objective');

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Number of Children", style: TextStyle(fontFamily: 'Objective', color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            _buildDropdown("Number of Children", "$numberOfChildren", numberOptions, onNumChildrenChanged),

            const SizedBox(height: 20),
            for (int i = 0; i < numberOfChildren; i++) ...[
              Text("Child ${i + 1} Age Range", style: titleStyle),
              const SizedBox(height: 8),
              _buildDropdown("Select age range", ageRanges[i], ageRangeOptions, (value) {
                setState(() => ageRanges[i] = value);
                updateSection();
              }),
              const SizedBox(height: 8),
            ],

            if (numberOfChildren > 0) ...[
              Row(
                children: [
                  Checkbox(
                    value: sameSchool,
                    activeColor: Colors.black,
                    onChanged: (val) {
                      setState(() => sameSchool = val ?? false);
                      updateSection();
                    },
                  ),
                  const Text("The children attend the same school", style: TextStyle(fontFamily: 'Objective')),
                ],
              ),
              const SizedBox(height: 8),
            ],

            for (int i = 0; i < (sameSchool ? 1 : numberOfChildren); i++) ...[
              const SizedBox(height: 12),
              Text("Child ${i + 1} Schooling Info", style: titleStyle),
              const SizedBox(height: 8),
              _buildDropdown("Schooling Type", schoolDetails[i]["schoolingType"], schoolingOptions, (val) {
                setState(() => schoolDetails[i]["schoolingType"] = val);
                updateSection();
              }),
              _buildDropdown("State", schoolDetails[i]["state"], mockStates, (val) {
                setState(() {
                  schoolDetails[i]["state"] = val;
                  schoolDetails[i]["lga"] = null;
                  schoolDetails[i]["area"] = null;
                });
                updateSection();
              }),
              if (schoolDetails[i]["state"] != null)
                _buildDropdown(
                  "Local Government Area",
                  schoolDetails[i]["lga"],
                  lgaMap[schoolDetails[i]["state"]] ?? [],
                  (val) {
                    setState(() {
                      schoolDetails[i]["lga"] = val;
                      schoolDetails[i]["area"] = null;
                    });
                    updateSection();
                  },
                ),
              if (schoolDetails[i]["lga"] != null)
                _buildDropdown(
                  "Area",
                  schoolDetails[i]["area"],
                  areaMap[schoolDetails[i]["lga"]] ?? [],
                  (val) {
                    setState(() => schoolDetails[i]["area"] = val);
                    updateSection();
                  },
                ),
              const SizedBox(height: 16),
            ],
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
      padding: const EdgeInsets.only(bottom: 12),
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
