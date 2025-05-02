import 'package:flutter/material.dart';
import 'bounce_tap.dart';

class ServiceDetailOptions extends StatefulWidget {
  final String serviceTitle;
  final List<Map<String, dynamic>> items;
  final Map<String, Map<String, String>>? initialSelections;
  final Function(String groupTitle, String category, String value)? onOptionSelected;
  

  const ServiceDetailOptions({
    super.key,
    required this.serviceTitle,
    required this.items,
    this.initialSelections,
    this.onOptionSelected,
  });

  @override
  State<ServiceDetailOptions> createState() => _ServiceDetailOptionsState();
}

class _ServiceDetailOptionsState extends State<ServiceDetailOptions> {
  final Map<String, Map<String, String>> selectedOptions = {};

  @override
  void initState() {
    super.initState();
    for (var item in widget.items) {
      final group = item['title'];
      final subOptions = item['subOptions'] as Map<String, List<String>>;
      selectedOptions[group] = {};

      for (var category in subOptions.keys) {
        selectedOptions[group]![category] =
            widget.initialSelections?[group]?[category] ?? '';
      }
    }
  }

  void updateSelection(String itemTitle, String category, String value) {
    setState(() {
      selectedOptions[itemTitle]![category] = value;
    });
    widget.onOptionSelected?.call(itemTitle, category, value);
}

  Widget buildRadioRow({
    required String label,
    required String groupValue,
    required VoidCallback onTap,
  }) {
    return BounceTap(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: label,
            groupValue: groupValue,
            onChanged: (_) => onTap(),
            activeColor: const Color(0xFFFFCC29),
          ),
          Text(label, style: const TextStyle(fontFamily: 'Objective')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 377),
      padding: const EdgeInsets.symmetric(horizontal: 20), // 👈 uniform padding here only
      child: SingleChildScrollView(
        child: Column(
          children: widget.items.map((item) {
            final title = item['title'];
            final subOptions = item['subOptions'] as Map<String, List<String>>;

            return Container(
              margin: const EdgeInsets.only(bottom: 16), // spacing between cards
              padding: const EdgeInsets.all(16),
              width: double.infinity, // 👈 full width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Objective',
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...subOptions.entries.map((entry) {
                    final category = entry.key;
                    final options = entry.value;
                    final selected = selectedOptions[title]![category] ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category, style: const TextStyle(fontFamily: 'Objective')),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: options.map((opt) {
                            return buildRadioRow(
                              label: opt,
                              groupValue: selected,
                              onTap: () => updateSelection(title, category, opt),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

}
