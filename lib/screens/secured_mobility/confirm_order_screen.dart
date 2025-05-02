import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_form_data_provider.dart';
import '../../../widgets/halogen_back_button.dart';
import 'package:intl/intl.dart';

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final allData = context.watch<UserFormDataProvider>().allSections['secured_mobility'] ?? {};

    final desired = allData['desired_services'] ?? {};
    final config = allData['service_configuration'] ?? {};
    final schedule = allData['schedule_service'] ?? {};
    final total = allData['total_cost'] ?? 0;

    return Scaffold(
      body: Container(
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
                    Text(
                      'Confirm Order',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Objective',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Objective',
                  ),
                ),
                const SizedBox(height: 16),
                _summaryCard('Trip Type', desired['trip_type']),
                if ((config['vehicle_choice']?['enabled'] ?? false))
                  _summaryCard('Vehicle Choice', config['vehicle_choice']['selection']),
                if ((config['pilot_vehicle']?['enabled'] ?? false))
                  _summaryCard('Pilot Vehicle', config['pilot_vehicle']['selection']),
                if ((config['in_car_protection']?['enabled'] ?? false))
                  _summaryCard('In Car Protection', config['in_car_protection']['selection']),
                _summaryCard('Pick Up Location', schedule['pickup_location']),
                _summaryCard('Drop Off Location', schedule['dropoff_location']),
                _summaryCard('Pick Up Date', _formatDate(schedule['pickup_date'])),
                _summaryCard('Pick Up Time', schedule['pickup_time']),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: ${formatCurrency(total)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Objective',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    onPressed: () {
                      final provider = context.read<UserFormDataProvider>();
                      provider.updateMobilityStage(5); // Move to Stage 5
                      Navigator.pop(context); // Return to parent screen (Secured Mobility)
                    },
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text(
                      'Confirm Order',
                      style: TextStyle(fontSize: 16, fontFamily: 'Objective'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(String title, dynamic value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        '$title: ${value ?? "-"}',
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'Objective',
        ),
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return "-";
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return "-";
    return DateFormat('dd/MM/yyyy').format(parsed);
  }
}
