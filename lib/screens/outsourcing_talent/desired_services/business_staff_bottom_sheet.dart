import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';
import 'front_desk_officer_detail_sheet.dart';
import 'direct_sales_agent_detail_sheet.dart';
import 'office_administrator_detail_sheet.dart';
import 'janitor_detail_sheet.dart';

class BusinessStaffBottomSheet extends StatelessWidget {
  const BusinessStaffBottomSheet({super.key});

  void _markBusinessStaffCompleted(BuildContext context) {
    final provider = context.read<UserFormDataProvider>();
    final currentData = provider.allSections['outsourcing_talent']?['desired_services'] ?? {};
    final businessStaff = currentData['business_staff'] ?? {};

    if (businessStaff.isNotEmpty) {
      provider.updateSection('outsourcing_talent', {
        ...provider.allSections['outsourcing_talent'],
        'desired_services': {
          ...currentData,
          'business_staff': {
            ...businessStaff,
            'completed': true,
          },
        },
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<UserFormDataProvider>().allSections['outsourcing_talent']?['desired_services'] ?? {};
    final businessStaff = data['business_staff'] ?? {};

    final items = [
      {'label': 'Front Desk Officers', 'key': 'front_desk_officer'},
      {'label': 'Direct Sales Agent', 'key': 'direct_sales_agent'},
      {'label': 'Office Administrator', 'key': 'office_administrator'},
      {'label': 'Janitor', 'key': 'janitor'},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 20),
              ),
              const Spacer(),
              const Text(
                'Business Staff',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Objective',
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
          const SizedBox(height: 24),
          ...items.map((item) {
            final roleData = businessStaff[item['key']] ?? {};
            final gender = roleData['gender'];
            final quantity = roleData['quantity'];

            final hasSelection = gender != null && quantity != null;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                item['label']!,
                style: const TextStyle(fontSize: 14, fontFamily: 'Objective'),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasSelection)
                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  if (quantity != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right_rounded, size: 22),
                    onPressed: () => _openDetail(context, item['label']! ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, String label) {
    void onSaved() {
      _markBusinessStaffCompleted(context); 

      final provider = context.read<UserFormDataProvider>();
      provider.calculateOutsourcingProgress(); 
    }

    Widget sheet;

    if (label == 'Front Desk Officers') {
      sheet = FrontDeskOfficerDetailSheet(onSaved: onSaved);
    } else if (label == 'Direct Sales Agent') {
      sheet = DirectSalesAgentDetailSheet(onSaved: onSaved);
    } else if (label == 'Office Administrator') {
      sheet = OfficeAdministratorDetailSheet(onSaved: onSaved);
    } else if (label == 'Janitor') {
      sheet = JanitorDetailSheet(onSaved: onSaved);
    } else {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }
}
