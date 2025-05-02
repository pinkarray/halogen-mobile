import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_form_data_provider.dart';
import 'driver_detail_sheet.dart';
import 'security_operatives_detail_sheet.dart';
import 'cook_detail_sheet.dart';
import 'housekeeper_detail_sheet.dart';

class DomesticStaffBottomSheet extends StatelessWidget {
  const DomesticStaffBottomSheet({super.key});

  void _markDomesticStaffCompleted(BuildContext context) {
    final provider = context.read<UserFormDataProvider>();
    final currentData =
        provider.allSections['outsourcing_talent']?['desired_services'] ?? {};

    final domesticStaffData = currentData['domestic_staff'] ?? {};

    // ✅ If the user has filled any detail (e.g., Drivers or Cooks)
    if (domesticStaffData.isNotEmpty) {
      provider.updateSection('outsourcing_talent', {
        ...provider.allSections['outsourcing_talent'],
        'desired_services': {
          ...currentData,
          'domestic_staff': {
            ...domesticStaffData,
            'completed': true, // ✅ Mark it completed here
          },
        },
        'current_stage': 2, // ✅ Move stage forward
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data =
        context
            .watch<UserFormDataProvider>()
            .allSections['outsourcing_talent']?['desired_services'] ??
        {};

    final items = ['Drivers', 'Security Operatives', 'Cooks', 'Housekeepers'];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Centered title with tappable close
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 20),
              ),
              const Spacer(),
              const Text(
                'Domestic Staff',
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

          ...items.map((label) {
            final key = label.toLowerCase().replaceAll(' ', '_');
            final domesticStaff = data['domestic_staff'] ?? {};
            final subItem = domesticStaff[key] ?? {};

            final quantity = subItem['quantity'];
            final hasSelection = subItem['type'] != null && quantity != null;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                label,
                style: const TextStyle(fontSize: 14, fontFamily: 'Objective'),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasSelection)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  if (quantity != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
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
                    icon: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      size: 22,
                    ),
                    onPressed: () => _openDetail(context, label),
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
      _markDomesticStaffCompleted(context);

      final provider = context.read<UserFormDataProvider>();
      provider.calculateOutsourcingProgress(); // ✅ Added
    }

    Widget sheet;

    if (label == 'Drivers') {
      sheet = DriverDetailSheet(onSaved: onSaved);
    } else if (label == 'Security Operatives') {
      sheet = SecurityOperativesDetailSheet(onSaved: onSaved);
    } else if (label == 'Cooks') {
      sheet = CookDetailSheet(onSaved: onSaved);
    } else if (label == 'Housekeepers') {
      sheet = HousekeeperDetailSheet(onSaved: onSaved);
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
