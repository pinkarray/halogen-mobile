import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart';
import '../../../providers/user_form_data_provider.dart';
import '../otp_verification/otp_verification_screen.dart';
import '../../../shared/widgets/custom_progress_bar.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/glowing_arrows.dart';

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
    context.read<UserFormDataProvider>().updateSignUpStep(2);
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
                  subStep: 2,
                  maxSubStepsPerStep: 3,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Add Phone Number",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Objective',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Input your active number to get OTP",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Objective',
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Container(
                      width: 110,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF1C2B66)),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedCountryCode,
                        underline: const SizedBox(),
                        items: ["+234", "+1", "+44", "+91"]
                            .map((String code) => DropdownMenuItem(
                                  value: code,
                                  child: Text(
                                    code,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Objective',
                                      color: Color(0xFF1C2B66),
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountryCode = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // ✅ restrict to digits
                        cursorColor: const Color(0xFF1C2B66),
                        decoration: InputDecoration(
                          hintText: "8156435467",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF1C2B66)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF1C2B66)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF1C2B66), width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
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

                                if (selectedCountryCode == '+234' && _phoneController.text.trim().length != 10) {
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Nigerian phone numbers must be 10 digits')),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  final fullPhoneNumber = '$selectedCountryCode${_phoneController.text.trim()}';

                                  // ✅ Send OTP
                                  final result = await sendOtp(phoneNumber: fullPhoneNumber);

                                  // ✅ Save phone + confirmationId to Provider
                                  provider.updateOnboardingInfo(phoneNumber: fullPhoneNumber);
                                  if (result.containsKey("confirmation_id")) {
                                    provider.saveConfirmationId(result["confirmation_id"]);
                                  }

                                  if (!mounted) return;

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 900),
                                      pageBuilder: (_, __, ___) => const OTPVerificationScreen(),
                                      transitionsBuilder: (_, animation, __, child) {
                                        return FadeTransition(opacity: animation, child: child);
                                      },
                                    ),
                                  );
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to send OTP: $e')),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.black,
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