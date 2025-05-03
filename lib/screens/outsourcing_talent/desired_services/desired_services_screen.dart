import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';
import '../../../../widgets/halogen_back_button.dart';
import '../../../../widgets/outsourcing_progress_bar.dart';
import 'domestic_staff_bottom_sheet.dart';
import 'business_staff_bottom_sheet.dart';
import 'background_checks_bottom_sheet.dart';
import 'investigation_bottom_sheet.dart';
import 'lea_liaison_services_bottom_sheet.dart';

class OutsourcingDesiredServicesScreen extends StatefulWidget {
  const OutsourcingDesiredServicesScreen({super.key});

  @override
  State<OutsourcingDesiredServicesScreen> createState() => _OutsourcingDesiredServicesScreenState();
}

class _OutsourcingDesiredServicesScreenState extends State<OutsourcingDesiredServicesScreen> {
  final services = [
    'Domestic Staff',
    'Business Staff',
    'Background Checks',
    'Investigation',
    'LEA Liaison Services',
  ];

  final sectionKeys = [
    'domestic_staff',
    'business_staff',
    'background_checks',
    'investigation',
    'lea_liaison',
  ];

  Map<String, bool> checkedStates = {};

  @override
  void initState() {
    super.initState();
    _loadCheckedStates(); // ✅ Only this
  }

  void _loadCheckedStates() {
    final provider = context.read<UserFormDataProvider>();
    final outsourcingData = Map<String, dynamic>.from(
      provider.allSections['outsourcing_talent'] ?? {},
    );
    final desiredServices = Map<String, dynamic>.from(
      outsourcingData['desired_services'] ?? {},
    );

    for (var key in sectionKeys) {
      final item = desiredServices[key];
      checkedStates[key] = item != null && (item is Map && item['completed'] == true);
    }
  }

  void _handleCheck(String key, bool value) {
    final provider = context.read<UserFormDataProvider>();
    final outsourcingData = Map<String, dynamic>.from(
      provider.allSections['outsourcing_talent'] ?? {},
    );
    final desiredServices = Map<String, dynamic>.from(
      outsourcingData['desired_services'] ?? {},
    );

    if (value) {
      desiredServices[key] = true;
    } else {
      desiredServices.remove(key);
    }

    provider.updateSection('outsourcing_talent', {
      ...outsourcingData,
      'desired_services': desiredServices,
    });

    setState(() {
      checkedStates[key] = value;
    });

    if (desiredServices.isNotEmpty) {
      provider.updateSection('outsourcing_talent', {
        ...outsourcingData,
        'current_stage': 2,
      });
    }
  }

  void _handleDropdownTap(String serviceKey) async {
    if (serviceKey == 'domestic_staff') {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const DomesticStaffBottomSheet(),
      );

      _loadCheckedStates();
      setState(() {});
    } else if (serviceKey == 'business_staff') {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const BusinessStaffBottomSheet(),
      );

      _loadCheckedStates();
      setState(() {});
    } else if (serviceKey == 'background_checks') {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const BackgroundChecksBottomSheet(), // ✅ New
      );

      _loadCheckedStates();
      setState(() {});
    } else if (serviceKey == 'investigation') {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const InvestigationBottomSheet(), // ✅ New
      );

      _loadCheckedStates();
      setState(() {});
    } else if (serviceKey == 'lea_liaison') {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const LeaLiaisonServicesBottomSheet(), // ✅ New
      );

      _loadCheckedStates();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserFormDataProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFFAEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    HalogenBackButton(),
                    SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Desired Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Objective',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                OutsourcingProgressBar(
                  currentStep: provider.getCurrentOutsourcingStage(),
                  stage1ProgressPercent: provider.stage1ProgressPercent,
                ),

                const SizedBox(height: 24),

                // 👇 Reduce visual dominance so gradient shines through
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92), // ⬅️ slightly transparent
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: List.generate(services.length, (index) {
                      final title = services[index];
                      final key = sectionKeys[index];
                      final isChecked = checkedStates[key] ?? false;

                      return Column(
                        children: [
                          ListTile(
                            leading: Checkbox(
                              value: isChecked,
                              onChanged: (val) => _handleCheck(key, val!),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              activeColor: Colors.black,
                            ),
                            title: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Objective',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
                              onPressed: () => _handleDropdownTap(key),
                            ),
                          ),
                          if (index != services.length - 1)
                            const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}