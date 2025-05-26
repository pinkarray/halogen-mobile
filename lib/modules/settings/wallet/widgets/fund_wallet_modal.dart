import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:halogen/main.dart';
import '../../../../shared/helpers/session_manager.dart';

class FundWalletModal extends StatefulWidget {
  final void Function(double amount) onConfirm;

  const FundWalletModal({super.key, required this.onConfirm});

  @override
  State<FundWalletModal> createState() => _FundWalletModalState();
}

class _FundWalletModalState extends State<FundWalletModal> {
  final TextEditingController amountController = TextEditingController();
  bool _isLoading = false; // Changed from final to regular variable
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await SessionManager.getUserProfile();
    setState(() {
      _userEmail = user?['email'] ?? "anonymous@halogen.com";
    });
    debugPrint("User email: $_userEmail");
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: bottomInset > 0 ? bottomInset : 24,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: const Color(0xFFFFFAEA), // Changed background color here
            elevation: 8,
            shadowColor: Colors.black26,
            child: IntrinsicHeight(
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  bottom: bottomInset > 0 ? 0 : 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFAEA), // Also updated header background to match
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: const Center(
                        child: Text(
                          "Add Money to Wallet",
                          style: TextStyle(
                            fontFamily: 'Objective',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Added to prevent flex issues
                        crossAxisAlignment: CrossAxisAlignment.stretch, // Better alignment
                        children: [
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Enter Amount (₦)",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.black12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F9FF),
                              prefixIcon: const Icon(Icons.attach_money, color: Colors.black54),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50, // Fixed height for button
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handlePayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      "Add Funds",
                                      style: TextStyle(
                                        fontFamily: 'Objective',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    if (_userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Loading user info... please try again")),
      );
      return;
    }

    // Show loading state
    setState(() {
      _isLoading = true;
    });

    // Close the keyboard
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 200));

    // Save values needed for payment
    final email = _userEmail!;
    final reference = "HLG-${DateTime.now().millisecondsSinceEpoch}";

    // Close modal before launching Paystack
    Navigator.of(context).pop();

    // Wait for modal to fully close before launching Paystack
    await Future.delayed(const Duration(milliseconds: 300));

    final charge = Charge()
      ..amount = (amount * 100).toInt()
      ..email = email
      ..reference = reference;

    try {
      final response = await paystackPlugin.checkout(
        navigatorKey.currentContext!, // 👈 launch from app-level context
        method: CheckoutMethod.card,
        charge: charge,
        fullscreen: false, // Changed to false to avoid fullscreen layout issues
        logo: Image.asset('assets/images/logo.png', width: 40, height: 40),
      );

      if (response.status == true) {
        debugPrint("✅ Payment Successful. Ref: ${response.reference}");
        Future.delayed(const Duration(milliseconds: 200), () {
          widget.onConfirm(amount);
        });
      } else {
        debugPrint("❌ Payment failed or was cancelled");
      }
    } catch (e) {
      debugPrint("❌ Paystack exception: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text("Payment error: $e")),
      );
    }
  }
}