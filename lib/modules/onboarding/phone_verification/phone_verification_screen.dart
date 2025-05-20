import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../../providers/user_form_data_provider.dart';
import '../otp_verification/otp_verification_screen.dart';
import '../../../shared/widgets/custom_progress_bar.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/glowing_arrows.dart';
import '../../../shared/widgets/underlined_glow_phone_field.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  PhoneVerificationScreenState createState() => PhoneVerificationScreenState();
}

class PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String selectedCountryCode = "+234";

  @override
  void initState() {
    super.initState();

    final provider = context.read<UserFormDataProvider>();
    provider.updateSignUpStep(2);

    if ((provider.phoneNumber ?? "").isEmpty) {
      provider.updatePhone("");
    }

    _phoneController.addListener(() {
      final fullPhone = '$selectedCountryCode${_phoneController.text.trim()}';
      provider.updatePhone(fullPhone);
      setState(() {}); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserFormDataProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const HalogenBackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFAEA),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomProgressBar(
                  currentStep: 1,
                  percent: provider.stage1ProgressPercent, // this returns 0.20 to ~0.25
                ),

                const SizedBox(height: 20),

                const Text(
                  "Add Phone Number",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Objective',
                    color: Color(0xFF1C2B66),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Input your active number to get OTP",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1C2B66),
                    fontFamily: 'Objective',
                  ),
                ),
                const SizedBox(height: 20),

                UnderlinedGlowPhoneField(
                  selectedCountryCode: selectedCountryCode,
                  onCountryCodeChanged: (val) => setState(() {
                    selectedCountryCode = val ?? "+234";
                  }),
                  phoneController: _phoneController,
                ),

                const SizedBox(height: 30),

                Center(
                  child: Hero(
                    tag: 'auth-button',
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_phoneController.text.isEmpty) {
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter your phone number')),
                                  );
                                  return;
                                }

                                if (selectedCountryCode == '+234' &&
                                    _phoneController.text.trim().length != 10) {
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Nigerian phone numbers must be 10 digits')),
                                  );
                                  return;
                                }

                                setState(() => _isLoading = true);

                                try {
                                  final fullPhoneNumber =
                                      '$selectedCountryCode${_phoneController.text.trim()}';

                                  final result = await sendOtp(phoneNumber: fullPhoneNumber);

                                  provider.updatePhone(fullPhoneNumber);
                                  if (result.containsKey("confirmation_id")) {
                                    provider.saveConfirmationId(result["confirmation_id"]);
                                  }

                                  if (!mounted) return;

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 900),
                                      pageBuilder: (_, __, ___) => const OTPVerificationScreen(),
                                      transitionsBuilder: (_, animation, __, child) =>
                                          FadeTransition(opacity: animation, child: child),
                                    ),
                                  );
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to send OTP: $e')),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Color(0xFF1C2B66),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Send the code",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Objective',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GlowingArrows(arrowColor: Colors.white),
                                ],
                              ),
                      ),
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
}
