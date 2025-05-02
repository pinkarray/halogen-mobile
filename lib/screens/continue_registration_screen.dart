import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_form_data_provider.dart';
import '../widgets/custom_progress_bar.dart';
import 'risk_section_a.dart';
import 'risk_section_b.dart';
import 'risk_section_c.dart';
import 'risk_section_d.dart';
import 'risk_section_e.dart';


class ContinueRegistrationScreen extends StatelessWidget {
  const ContinueRegistrationScreen({super.key});

  final List<String> sectionTitles = const [
    "Principal Profile",
    "Spouse",
    "Number of Children",
    "Home Address",
    "Type of Residence",
    "Occupation - Principal",
    "Occupation - Spouse",
    "Domestic Support",
    "Socials - Principal",
    "Socials - Spouse",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    final completedSections =
        context.watch<UserFormDataProvider>().allSections.keys.toSet();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Progress bar
            CustomProgressBar(
              currentStep: 2,
              subStep: completedSections.length,
              maxSubStepsPerStep: sectionTitles.length,
            ),

            const SizedBox(height: 16),

            // ✅ Section tiles (A–K)
            Expanded(
              child: ListView.builder(
                itemCount: sectionTitles.length,
                itemBuilder: (context, index) {
                  final sectionLetter = String.fromCharCode(
                    65 + index,
                  ); // A, B, C...
                  final isCompleted = completedSections.contains(sectionLetter);

                  return GestureDetector(
                    onTap: () {
                      if (sectionLetter == "A") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrincipalProfileScreen(),
                          ),
                        );
                      } else if (sectionLetter == "B") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SpouseProfileScreen(),
                          ),
                        );
                      }else if (sectionLetter == "C") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChildrenInfoScreen()),
                        );
                      }else if (sectionLetter == "D") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeAddressScreen()),
                        );
                      }else if (sectionLetter == "E") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ResidenceTypeScreen()),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2B66), // dark blue background
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: Text(
                              sectionLetter,
                              style: const TextStyle(
                                fontFamily: 'Objective',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              sectionTitles[index],
                              style: const TextStyle(
                                fontFamily: 'Objective',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white, // white text on dark tile
                              ),
                            ),
                          ),
                          if (isCompleted)
                            const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
