import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_form_data_provider.dart';
import '../widgets/custom_progress_bar.dart';
import '../widgets/glowing_arrows.dart';
import '../widgets/halogen_back_button.dart';
import 'phone_verification_screen.dart';
import '../widgets/shake_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<ShakeWidgetState> _passwordFieldKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _confirmPasswordFieldKey = GlobalKey<ShakeWidgetState>();
  bool _isChecked = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  
  @override
  void initState() {
    super.initState();
    context.read<UserFormDataProvider>().updateSignUpStep(1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserFormDataProvider>();

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
                  currentStep: provider.currentSignUpStep,
                  subStep: provider.currentSignUpStep,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Let's get you started",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Objective',
                  ),
                ),
                const Text(
                  'Join Halogen and experience seamless security',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Objective',
                  ),
                ),
                const SizedBox(height: 20),

                _buildTextField(hint: "Full name", controller: fullNameController),
                _buildTextField(hint: "Email Address", controller: emailController),
                _buildTextField(
                  hint: "Password",
                  controller: passwordController,
                  obscureText: true,
                  obscureToggleValue: _obscurePassword,
                  onToggle: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  key: _passwordFieldKey,
                ),
                _buildTextField(
                  hint: "Confirm Password",
                  controller: confirmPasswordController,
                  obscureText: true,
                  obscureToggleValue: _obscureConfirmPassword,
                  onToggle: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  key: _confirmPasswordFieldKey,
                ),

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isChecked,
                      activeColor: const Color.fromARGB(255, 0, 0, 0),
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text.rich(
                          TextSpan(
                            text: 'By registering, you accept our ',
                            style: const TextStyle(fontFamily: 'Objective'),
                            children: const [
                              TextSpan(
                                text: 'Terms of Use',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Center(
                  child: Hero(
                    tag: 'auth-button',
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _isChecked && !_isLoading
                            ? () async {
                                if (fullNameController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    confirmPasswordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please fill all fields')),
                                  );
                                  return;
                                }

                                if (passwordController.text != confirmPasswordController.text) {
                                  _passwordFieldKey.currentState?.shake();
                                  _confirmPasswordFieldKey.currentState?.shake();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Passwords do not match')),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  // ✅ Save details in Provider, NOT backend yet
                                  provider.updateOnboardingInfo(
                                    fullName: fullNameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  if (!mounted) return;

                                  // ✅ Go to phone number input + verification screen
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 900),
                                      pageBuilder: (_, __, ___) => const PhoneVerificationScreen(),
                                      transitionsBuilder: (_, animation, __, child) {
                                        return FadeTransition(opacity: animation, child: child);
                                      },
                                    ),
                                  );
                                } catch (e) {
                                  debugPrint('❌ Error: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Something went wrong: $e')),
                                  );
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: _isChecked ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey[300],
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
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Objective',
                                    ),
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
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
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
