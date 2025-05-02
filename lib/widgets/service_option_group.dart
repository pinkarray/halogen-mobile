import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_form_data_provider.dart';

class ServiceOptionGroup extends StatefulWidget {
  final String title;
  final String sectionKey; // e.g. 'vehicle_choice'
  final List<String> options;

  const ServiceOptionGroup({
    super.key,
    required this.title,
    required this.sectionKey,
    required this.options,
  });

  @override
  State<ServiceOptionGroup> createState() => _ServiceOptionGroupState();
}

class _ServiceOptionGroupState extends State<ServiceOptionGroup> {
  bool isEnabled = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final data = provider.allSections['secured_mobility']?['service_configuration']?[widget.sectionKey] ?? {};
    setState(() {
      isEnabled = data['enabled'] ?? false;
      selectedOption = data['selection'];
    });
  }

  void _handleSelection(String value) {
    setState(() => selectedOption = value);
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final config = provider.allSections['secured_mobility']?['service_configuration'] ?? {};

    config[widget.sectionKey] = {
      'enabled': isEnabled,
      'selection': value,
    };

    provider.updateSection('secured_mobility', {
      ...provider.allSections['secured_mobility'] ?? {},
      'service_configuration': config,
    });
  }

  void _toggleEnabled(bool value) {
    setState(() => isEnabled = value);
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final config = provider.allSections['secured_mobility']?['service_configuration'] ?? {};

    config[widget.sectionKey] = {
      'enabled': value,
      'selection': selectedOption,
    };

    provider.updateSection('secured_mobility', {
      ...provider.allSections['secured_mobility'] ?? {},
      'service_configuration': config,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: isEnabled,
          onChanged: (value) => _toggleEnabled(value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Objective',
            ),
          ),
        ),
        if (isEnabled)
          Column(
            children: widget.options.map((option) {
              final isSelected = selectedOption == option;
              return GestureDetector(
                onTap: () => _handleSelection(option),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Objective',
                            color: isSelected ? Colors.black : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}