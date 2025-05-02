import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/physical_security_progress_bar.dart';
import '../widgets/halogen_back_button.dart';
import '../widgets/bounce_tap.dart';
import '../widgets/selectable_option_tile.dart';
import '../widgets/service_detail_options.dart';
import '../widgets/glowing_arrows_button.dart';
import 'package:provider/provider.dart';
import '../providers/user_form_data_provider.dart';

class DesiredServicesScreen extends StatefulWidget {
  const DesiredServicesScreen({super.key});

  @override
  State<DesiredServicesScreen> createState() => _DesiredServicesScreenState();
}

class _DesiredServicesScreenState extends State<DesiredServicesScreen> {
  void _markServiceComplete(String serviceName) {
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final existing = Map<String, dynamic>.from(
      provider.allSections['desired_services'] ?? {},
    );
    final selected = Set<String>.from(existing['selected'] ?? []);

    if (!selected.contains(serviceName)) {
      selected.add(serviceName);
      existing['selected'] = selected.toList();
      provider.updateSection('desired_services', existing);
    }

    // ✅ If user has selected all 5 services, show the modal
    if (selected.length == 5) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _showSubmissionSuccessModal(context);
      });
    }
  }

  void _showSubmissionSuccessModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logocut.png', height: 70), // update this path if needed
                const SizedBox(height: 20),
                const Text(
                  "Details Submitted!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Objective',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your inspection has been successfully\nscheduled and is currently in the queue.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontFamily: 'Objective',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GlowingArrowsButton(
                  text: 'Okay',
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/services',
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
  }) {
    final provider = Provider.of<UserFormDataProvider>(context, listen: false);
    final structuredItems = getStructuredItems(title);

    final fullState = provider.allSections['desired_services'] ?? {};
    Map<String, Map<String, String>> initialSelections = {};

    if (fullState[title] != null && fullState[title] is Map<String, dynamic>) {
      final rawServiceData = fullState[title] as Map<String, dynamic>;

      // Filter out non-subgroups like 'selected'
      rawServiceData.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          initialSelections[key] = Map<String, String>.from(value);
        }
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 420,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BounceTap(
                          onTap: () => Navigator.of(context).pop(),
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFFF6F6F6),
                            child: Icon(Icons.close, size: 16, color: Colors.black),
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Objective',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 32),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: structuredItems.isNotEmpty
                          ? ServiceDetailOptions(
                              serviceTitle: title,
                              items: structuredItems,
                              initialSelections: initialSelections,
                              onOptionSelected: (group, category, value) {
                                final existing = Map<String, dynamic>.from(
                                  provider.allSections['desired_services'] ?? {},
                                );

                                final selected = Set<String>.from(existing['selected'] ?? []);
                                if (!selected.contains(title)) {
                                  selected.add(title);
                                  existing['selected'] = selected.toList();
                                }

                                existing[title] ??= {};
                                existing[title][group] ??= {};
                                existing[title][group][category] = value;

                                provider.updateSection('desired_services', existing);
                                _markServiceComplete(title);
                                setModalState(() {});
                              },
                            )
                          : ListView(
                              children: options.map((option) {
                                return SelectableOptionTile(
                                  label: option,
                                  isSelected: provider.allSections['desired_services']?['flatSelections']?[title] == option,
                                  onTap: () {
                                    final existing = Map<String, dynamic>.from(
                                      provider.allSections['desired_services'] ?? {},
                                    );

                                    final selected = Set<String>.from(existing['selected'] ?? []);
                                    if (!selected.contains(title)) {
                                      selected.add(title);
                                      existing['selected'] = selected.toList();
                                    }

                                    existing['flatSelections'] ??= {};
                                    existing['flatSelections'][title] = option;

                                    provider.updateSection('desired_services', existing);
                                    _markServiceComplete(title);
                                    setModalState(() {});
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserFormDataProvider>(
      builder: (context, provider, _) {
        final selectedList =
            provider.allSections['desired_services']?['selected'] ?? [];
        final currentStep = 1 + (selectedList as List).length;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFFFFAEA)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const HalogenBackButton(),
                        Expanded(
                          child: Text(
                                "Physical Security",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Objective',
                                ),
                              )
                              .animate()
                              .fade(duration: 400.ms)
                              .slideY(begin: 0.3, end: 0),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PhysicalSecurityProgressBar(
                      currentStep: currentStep,
                      progressContext: 'services',
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Desired Services",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Objective',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Choose the services you would love to subscribe to",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildServiceTile("Perimeter Protection"),
                          _buildServiceTile("Patrol"),
                          _buildServiceTile("Visitor Management System"),
                          _buildServiceTile("Intrusion Detection"),
                          _buildServiceTile("Alarm"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceTile(String title) {
    return Consumer<UserFormDataProvider>(
      builder: (context, provider, _) {
        final selected =
            provider.allSections['desired_services']?['selected'] ?? [];
        final isSelected = (selected as List).contains(title);

        return BounceTap(
          onTap: () => _showBottomSheet(context: context, title: title, options: []),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
              border: isSelected 
                  ? Border.all(color: Colors.green.withOpacity(0.5), width: 1.5) 
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      )
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Objective',
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: isSelected ? Colors.green : Colors.black54,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> getStructuredItems(String title) {
    switch (title) {
      case "Perimeter Protection":
        return [
          {
            'title': 'Electric Fence',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
          {
            'title': 'CCTV',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
        ];

      case "Patrol":
        return [
          {
            'title': 'Unarmed Patrol',
            'subOptions': {
              'Hour coverage': ['12 hours', '24 hours'],
            },
          },
          {
            'title': 'Armed Patrol',
            'subOptions': {
              'Hour coverage': ['12 hours', '24 hours'],
            },
          },
        ];

      case "Visitor Management System":
        return [
          {
            'title': 'Visitor Management System (VSM)',
            'subOptions': {
              'Select Configuration': [
                'Visitor Management System Only',
                'VMS + Communication Devices (Intercom)',
                'VMS + Communication Devices (CUG)',
              ],
            },
          },
        ];

      case "Intrusion Detection":
        return [
          {
            'title': 'Perimeter Radar System / Monitors',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
          {
            'title': 'Ground level Doors – All External Doors Monitor',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
          {
            'title': 'Ground level Windows – All Windows Monitor',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
          {
            'title': 'Interior Access Way Monitors',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
        ];

      case "Alarm":
        return [
          {
            'title': 'Interior Fire Alarm',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
          {
            'title': 'Interior Fire & Smoke Alarm',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
          {
            'title': 'Interior CO2 / Moisture / Air Quality',
            'subOptions': {
              'Monitoring': ['With monitoring', 'Without monitoring'],
              'Response': ['With Response', 'Without Response'],
            },
          },
        ];

      default:
        return [];
    }
  }
}
