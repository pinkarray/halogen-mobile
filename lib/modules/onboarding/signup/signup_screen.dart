import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/custom_progress_bar.dart';
import '../../../shared/widgets/glowing_arrows.dart';
import '../../../shared/widgets/halogen_back_button.dart';
import '../../../shared/widgets/shake_widget.dart';
import '../phone_verification/phone_verification_screen.dart';
import 'signup_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ShakeWidgetState> _passwordFieldKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _confirmPasswordFieldKey = GlobalKey<ShakeWidgetState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final signUpProvider = context.watch<SignUpProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
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
            colors: [Color(0xFFFFFAEA), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomProgressBar(currentStep: 1, subStep: 1, maxSubStepsPerStep: 3),
                const SizedBox(height: 20),
                const Text(
                  "Let's get you started",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Objective'),
                ),
                const Text(
                  'Join Halogen and experience seamless security',
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Objective'),
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  hint: "Full name",
                  controller: fullNameController,
                  onChanged: signUpProvider.updateFullName,
                ),
                _buildTextField(
                  hint: "Email Address",
                  controller: emailController,
                  onChanged: signUpProvider.updateEmail,
                ),
                _buildTextField(
                  hint: "Password",
                  controller: passwordController,
                  obscureText: true,
                  obscureToggleValue: _obscurePassword,
                  onToggle: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  onChanged: signUpProvider.updatePassword,
                  key: _passwordFieldKey,
                ),
                _buildTextField(
                  hint: "Confirm Password",
                  controller: confirmPasswordController,
                  obscureText: true,
                  obscureToggleValue: _obscureConfirmPassword,
                  onToggle: () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                  onChanged: signUpProvider.updateConfirmPassword,
                  key: _confirmPasswordFieldKey,
                ),

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: signUpProvider.isChecked,
                      activeColor: Colors.black,
                      onChanged: signUpProvider.toggleCheckbox,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text.rich(
                          TextSpan(
                            text: 'By registering, you accept our ',
                            style: const TextStyle(fontFamily: 'Objective'),
                            children: const [
                              TextSpan(text: 'Terms of Use', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' and '),
                              TextSpan(text: 'Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (signUpProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      signUpProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 20),

                Center(
                  child: Hero(
                    tag: 'auth-button',
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: signUpProvider.isChecked && !signUpProvider.isLoading
                            ? () async {
                                final success = await signUpProvider.submitForm();
                                if (success && mounted) {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 900),
                                      pageBuilder: (_, __, ___) => const PhoneVerificationScreen(),
                                      transitionsBuilder: (_, animation, __, child) =>
                                          FadeTransition(opacity: animation, child: child),
                                    ),
                                  );
                                } else {
                                  // animate shake only when passwords mismatch
                                  if (signUpProvider.password != signUpProvider.confirmPassword) {
                                    _passwordFieldKey.currentState?.shake();
                                    _confirmPasswordFieldKey.currentState?.shake();
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor:
                              signUpProvider.isChecked ? Colors.black : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: signUpProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Continue',
                                    style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Objective'),
                                  ),
                                  SizedBox(width: 10),
                                  GlowingArrows(),
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

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
    bool? obscureToggleValue,
    VoidCallback? onToggle,
    Key? key,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ShakeWidget(
        key: key,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureToggleValue ?? false,
          cursorColor: const Color(0xFF1C2B66),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: obscureText
                ? IconButton(
                    onPressed: onToggle,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        obscureToggleValue! ? Icons.visibility_off : Icons.visibility,
                        key: ValueKey(obscureToggleValue),
                        color: Colors.grey,
                      ),
                    ),
                  )
                : null,
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
    );
  }
}