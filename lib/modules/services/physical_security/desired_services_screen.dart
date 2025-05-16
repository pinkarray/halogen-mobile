import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/widgets/physical_security_progress_bar.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/selectable_option_tile.dart';
import '../../../shared/widgets/service_detail_options.dart';
import '../../../shared/widgets/glowing_arrows_button.dart';
import 'package:provider/provider.dart';
import './providers/physical_security_provider.dart';
import '../../../shared/widgets/home_wrapper.dart';

class DesiredServicesScreen extends StatefulWidget {
  const DesiredServicesScreen({super.key});

  @override
  State<DesiredServicesScreen> createState() => _DesiredServicesScreenState();
}

class _DesiredServicesScreenState extends State<DesiredServicesScreen> {
  void _markServiceComplete(String title) {
    final provider = Provider.of<PhysicalSecurityProvider>(context, listen: false);
    provider.markServiceComplete(title);

    if (provider.selectedServices.length == 5) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
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
                Image.asset('assets/images/logocut.png', height: 70),
                const SizedBox(height: 20),
                const Text("Details Submitted!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Objective')),
                const SizedBox(height: 12),
                const Text("Your inspection has been successfully\nscheduled and is currently in the queue.",
                    style: TextStyle(fontSize: 13, color: Colors.black54, fontFamily: 'Objective'), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                GlowingArrowsButton(
                  text: 'Okay',
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeWrapper(initialIndex: 1)), // 1 = Services tab
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

  void _showBottomSheet({required String title, required List<String> options}) {
    final provider = Provider.of<PhysicalSecurityProvider>(context, listen: false);
    final structuredItems = getStructuredItems(title);

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
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Objective')),
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
                              initialSelections: provider.structuredSelections[title] ?? {},
                              onOptionSelected: (group, category, value) {
                                provider.updateStructuredSelection(title, group, category, value);
                                setModalState(() {});
                              },
                            )
                          : ListView(
                              children: options.map((option) {
                                return SelectableOptionTile(
                                  label: option,
                                  isSelected: provider.flatSelections[title] == option,
                                  onTap: () {
                                    provider.updateFlatSelection(title, option);
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
      }).then((_) {
        final structured = provider.structuredSelections[title];
        final flat = provider.flatSelections[title];

        final hasStructuredInput = structured?.values.any((group) =>
            group.values.any((value) => value.toString().isNotEmpty)) ?? false;

        final hasFlatInput = flat?.toString().isNotEmpty ?? false;

        if (hasStructuredInput || hasFlatInput) {
          _markServiceComplete(title);
        } else {
          print("⚠️ No valid input for '$title' — service not marked complete.");
        }
      }
    );
  }

  Widget _buildServiceTile(String title, int index, IconData icon) {
    return Consumer<PhysicalSecurityProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.selectedServices.contains(title);

        bool enabled = true;
        if (index > 0) {
          final previousTitles = [
            "Perimeter Protection",
            "Patrol",
            "Visitor Management System",
            "Intrusion Detection",
            "Alarm"
          ];
          final previousTitle = previousTitles[index - 1];
          enabled = provider.selectedServices.contains(previousTitle);
        }

        Widget trailingIcon;
        if (isSelected) {
          trailingIcon = const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.green,
            child: Icon(Icons.check, size: 14, color: Colors.white),
          );
        } else {
          trailingIcon = Icon(Icons.arrow_forward_ios_rounded,
              size: 18, color: enabled ? Colors.black45 : Colors.grey);
        }

        final tileContent = Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.05 * 255).toInt()),
                blurRadius: 6,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon,
                      size: 20,
                      color: enabled
                          ? (isSelected ? Colors.green : Colors.black87)
                          : Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Objective',
                      fontWeight: FontWeight.w600,
                      color: enabled
                          ? (isSelected ? Colors.green : Colors.black)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              trailingIcon,
            ],
          ),
        );

        if (!enabled) {
          return Opacity(
            opacity: 0.4,
            child: IgnorePointer(child: tileContent),
          );
        }

        return BounceTap(
          onTap: () => _showBottomSheet(title: title, options: []),
          child: tileContent,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhysicalSecurityProvider>(
      builder: (context, provider, _) {
        final currentStep = 1 + provider.selectedServices.length;

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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const HalogenBackButton(),
                        Expanded(
                          child: Text("Physical Security",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Objective'))
                              .animate()
                              .fade(duration: 400.ms)
                              .slideY(begin: 0.3, end: 0),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PhysicalSecurityProgressBar(currentStep: currentStep, progressContext: 'services'),
                    const SizedBox(height: 24),
                    const Text("Desired Services",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Objective')),
                    const SizedBox(height: 4),
                    const Text("Choose the services you would love to subscribe to",
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildServiceTile("Perimeter Protection", 0, Icons.security),
                          _buildServiceTile("Patrol", 1, Icons.directions_walk),
                          _buildServiceTile("Visitor Management System", 2, Icons.how_to_reg),
                          _buildServiceTile("Intrusion Detection", 3, Icons.sensors),
                          _buildServiceTile("Alarm", 4, Icons.notifications_active),
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
