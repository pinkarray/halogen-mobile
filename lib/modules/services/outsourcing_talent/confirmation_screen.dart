import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/outsourcing_talent_provider.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/glowing_arrows_button.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  void _handleSubmit(BuildContext context) async {
    final provider = context.read<OutsourcingTalentProvider>();
    provider.markStage3Completed(); // ✅ mark stage complete

    await Future.delayed(const Duration(milliseconds: 500));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logocut.png', height: 80),
              const SizedBox(height: 24),
              const Text(
                'Submitted!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Objective',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'A customer advocate will contact you soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Objective',
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              GlowingArrowsButton(
                text: 'Okay',
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/outsourcing-talent'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Objective',
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Objective',
                    ),
                  ),
                  const Divider(height: 20, color: Color(0xFFE0E0E0)),
                ],
              )),
        ],
      ),
    );
  }

  List<String> _extractDomesticStaff(Map<String, dynamic> data) {
    final List<String> items = [];

    if (data['drivers'] != null) {
      items.add('Driver');
      items.add('${data['drivers']['type']} (${data['drivers']['quantity']})');
    }
    if (data['security_operatives'] != null) {
      items.add('Security Operatives');
      if (data['security_operatives']['armed'] != null) {
        items.add('Armed Security – ${data['security_operatives']['armed']}');
      }
      if (data['security_operatives']['unarmed'] != null) {
        data['security_operatives']['unarmed'].forEach((k, v) {
          items.add('$k ($v)');
        });
      }
    }
    if (data['cooks'] != null) {
      items.add('Cook');
      items.add('${data['cooks']['type']} (${data['cooks']['quantity']})');
    }
    if (data['housekeepers'] != null) {
      items.add('Housekeeper');
      items.add('${data['housekeepers']['type']} (${data['housekeepers']['quantity']})');
    }

    return items;
  }

  List<String> _extractBusinessStaff(Map<String, dynamic> data) {
    final List<String> items = [];

    for (var role in [
      'front_desk_officer',
      'direct_sales_agent',
      'office_administrator',
      'janitor'
    ]) {
      if (data[role] != null) {
        items.add(role.replaceAll('_', ' ').toTitleCase());
        data[role].forEach((k, v) {
          if (k != 'completed') items.add('$k ($v)');
        });
      }
    }

    return items;
  }

  List<String> _extractSimple(Map<String, dynamic> data) {
    final List<String> items = [];
    data.forEach((k, v) {
      if (k != 'completed') items.add('$k ($v)');
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OutsourcingTalentProvider>();
    final data = provider.allSectionDetails;

    final bool hasAnyData = data.isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFFFFAEA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Centered Header
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: HalogenBackButton(),
                    ),
                    Text(
                      'Confirmation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Objective',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ✅ Data Sections
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data['domestic_staff'] != null)
                        _buildSection('Domestic Staff', _extractDomesticStaff(data['domestic_staff']!)),
                      if (data['business_staff'] != null)
                        _buildSection('Business Staff', _extractBusinessStaff(data['business_staff']!)),
                      if (data['background_checks'] != null)
                        _buildSection('Background Checks', _extractSimple(data['background_checks']!)),
                      if (data['investigation'] != null)
                        _buildSection('Investigation', _extractSimple(data['investigation']!)),
                      if (data['lea_liaison'] != null)
                        _buildSection('LEA Liaison', _extractSimple(data['lea_liaison']!)),
                      if (data['description'] != null &&
                          data['description']!['text'].toString().isNotEmpty)
                        _buildSection('Description', [data['description']!['text']]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ✅ Submit Button
              Center(
                child: GlowingArrowsButton(
                  text: 'Submit',
                  onPressed: hasAnyData ? () => _handleSubmit(context) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  String toTitleCase() {
    return split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}