import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_form_data_provider.dart';
import '../../../widgets/halogen_back_button.dart';
import '../../../widgets/glowing_arrows_button.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  void _handleSubmit(BuildContext context) async {
    final provider = context.read<UserFormDataProvider>();

    provider.markStage3Completed();

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
              ))
        ],
      ),
    );
  }

  List<String> _extractDomesticStaff(Map<String, dynamic> domesticStaff) {
    final List<String> items = [];

    if (domesticStaff['drivers'] != null) {
      items.add('Driver');
      items.add('${domesticStaff['drivers']['type']} (${domesticStaff['drivers']['quantity']})');
    }
    if (domesticStaff['security_operatives'] != null) {
      items.add('Security Operatives');
      if (domesticStaff['security_operatives']['armed'] != null) {
        items.add('Armed Security – ${domesticStaff['security_operatives']['armed']}');
      }
      if (domesticStaff['security_operatives']['unarmed'] != null) {
        domesticStaff['security_operatives']['unarmed'].forEach((k, v) {
          items.add('$k ($v)');
        });
      }
    }
    if (domesticStaff['cooks'] != null) {
      items.add('Cook');
      items.add('${domesticStaff['cooks']['type']} (${domesticStaff['cooks']['quantity']})');
    }
    if (domesticStaff['housekeepers'] != null) {
      items.add('Housekeeper');
      items.add('${domesticStaff['housekeepers']['type']} (${domesticStaff['housekeepers']['quantity']})');
    }

    return items;
  }

  List<String> _extractBusinessStaff(Map<String, dynamic> businessStaff) {
    final List<String> items = [];

    if (businessStaff['front_desk_officer'] != null) {
      items.add('Front Desk Officer');
      businessStaff['front_desk_officer'].forEach((k, v) {
        if (k != 'completed') items.add('$k ($v)');
      });
    }
    if (businessStaff['direct_sales_agent'] != null) {
      items.add('Direct Sales Agent');
      businessStaff['direct_sales_agent'].forEach((k, v) {
        if (k != 'completed') items.add('$k ($v)');
      });
    }
    if (businessStaff['office_administrator'] != null) {
      items.add('Office Administrator');
      businessStaff['office_administrator'].forEach((k, v) {
        if (k != 'completed') items.add('$k ($v)');
      });
    }
    if (businessStaff['janitor'] != null) {
      items.add('Janitor');
      businessStaff['janitor'].forEach((k, v) {
        if (k != 'completed') items.add('$k ($v)');
      });
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
    final provider = context.watch<UserFormDataProvider>();

    final outsourcingDataRaw = provider.allSections['outsourcing_talent'] ?? {};

    final Map<String, dynamic> outsourcingData = Map<String, dynamic>.from(outsourcingDataRaw);

    final desiredServicesRaw = outsourcingData['desired_services'] ?? {};
    final Map<String, dynamic> desiredServices = Map<String, dynamic>.from(desiredServicesRaw);

    final description = outsourcingData['description'] as String? ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFFAEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                HalogenBackButton(),
                SizedBox(width: 12),
                Text(
                  'Confirmation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Objective',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (desiredServices['domestic_staff'] != null)
                      _buildSection('Domestic Staff', _extractDomesticStaff(
                        Map<String, dynamic>.from(desiredServices['domestic_staff']),
                      )),
                    if (desiredServices['business_staff'] != null)
                      _buildSection('Business Staff', _extractBusinessStaff(
                        Map<String, dynamic>.from(desiredServices['business_staff']),
                      )),
                    if (desiredServices['background_checks'] != null)
                      _buildSection('Background Checks', _extractSimple(
                        Map<String, dynamic>.from(desiredServices['background_checks']),
                      )),
                    if (desiredServices['investigation'] != null)
                      _buildSection('Investigation', _extractSimple(
                        Map<String, dynamic>.from(desiredServices['investigation']),
                      )),
                    if (description.isNotEmpty)
                      _buildSection('Description', [description]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: GlowingArrowsButton(
                text: 'Submit',
                onPressed: () => _handleSubmit(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
