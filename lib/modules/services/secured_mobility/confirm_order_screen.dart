import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'providers/secured_mobility_provider.dart';
import '../../../shared/widgets/halogen_back_button.dart';

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SecuredMobilityProvider>();

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
                _summaryCard('Trip Type', provider.tripType),
                if ((provider.serviceConfiguration['vehicle_choice']?['enabled'] ?? false))
                  _summaryCard('Vehicle Choice', provider.serviceConfiguration['vehicle_choice']?['selection']),
                if ((provider.serviceConfiguration['pilot_vehicle']?['enabled'] ?? false))
                  _summaryCard('Pilot Vehicle', provider.serviceConfiguration['pilot_vehicle']?['selection']),
                if ((provider.serviceConfiguration['in_car_protection']?['enabled'] ?? false))
                  _summaryCard('In Car Protection', provider.serviceConfiguration['in_car_protection']?['selection']),
                _summaryCard('Pick Up Location', provider.pickupLocation),
                _summaryCard('Drop Off Location', provider.dropoffLocation),
                _summaryCard('Pick Up Date', _formatDate(provider.pickupDate)),
                _summaryCard('Pick Up Time', _formatTime(provider.pickupTime)),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: ${formatCurrency(provider.totalCost)}',
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
                      provider.markStageComplete(5);
                      Navigator.pop(context);
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

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "-";
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
