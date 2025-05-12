import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'providers/secured_mobility_provider.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/glowing_arrows_button.dart';
import '../../../main.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;

  Future<void> _payWithPaystack(BuildContext context, int amount) async {
    final charge = Charge()
      ..amount = amount * 100
      ..email = 'testuser@halogen.com'
      ..currency = 'NGN'
      ..reference = 'halogen_${DateTime.now().millisecondsSinceEpoch}';

    CheckoutResponse response = await paystackPlugin.checkout(
      context,
      charge: charge,
      method: CheckoutMethod.card,
      fullscreen: false,
      logo: Image.asset('assets/images/logocut.png', width: 40, height: 40),
    );

    if (!mounted) return;

    if (response.status == true) {
      final provider = context.read<SecuredMobilityProvider>();
      provider.markStageComplete(5);
      Navigator.of(context).pushNamedAndRemoveUntil('/services', (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed or cancelled')),
      );
    }
  }

  void _showBankTransferBottomSheet(BuildContext context, int amount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Transfer to the account below:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Account Name: Halogen Test'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Account Number: 0123456789'),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: '0123456789'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Account number copied')),
                          );
                        },
                      ),
                    ],
                  ),
                  const Text('Bank: GTBank'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Amount: ${formatCurrency(amount)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            GlowingArrowsButton(
              text: "I've sent the money",
              onPressed: () {
                final provider = context.read<SecuredMobilityProvider>();
                provider.markStageComplete(5);
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/services', (_) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SecuredMobilityProvider>();
    final totalCost = provider.totalCost;

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
                    Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Objective',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2B66),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Objective',
                        ),
                      ),
                      Text(
                        'NGN500,000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Objective',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'Objective',
                  ),
                ),
                const SizedBox(height: 12),
                _paymentOption('Wallet'),
                _paymentOption('Card'),
                _paymentOption('Bank Transfer'),
                const SizedBox(height: 32),
                Center(
                  child: GlowingArrowsButton(
                    text: 'Pay ${formatCurrency(totalCost)}',
                    onPressed: () async {
                      if (selectedMethod == 'Card') {
                        await _payWithPaystack(context, totalCost);
                      } else if (selectedMethod == 'Bank Transfer') {
                        _showBankTransferBottomSheet(context, totalCost);
                      } else {
                        provider.markStageComplete(5);
                        Navigator.of(context).pushNamedAndRemoveUntil('/services', (_) => false);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentOption(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, fontFamily: 'Objective'),
              ),
            ),
            Icon(
              selectedMethod == title
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}