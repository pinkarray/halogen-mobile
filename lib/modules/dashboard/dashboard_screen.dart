import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/user_form_data_provider.dart';
import 'widgets/greeting_header.dart';
import 'widgets/dashboard_search_bar.dart';
import 'widgets/continue_registration_prompt.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRegistered = context.watch<UserFormDataProvider>().isFullyRegistered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const GreetingHeader()
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: -0.2),
              const SizedBox(height: 20),
              const DashboardSearchBar()
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: -0.3),
              const SizedBox(height: 20),
              const Text(
                "Services",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Objective',
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.2),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: isRegistered
                      ? const Text(
                          "Services will appear here once available.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Objective',
                          ),
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1)
                      : ContinueRegistrationPrompt(
                          onContinue: () =>
                              Navigator.pushNamed(context, '/continue-registration'),
                        )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
