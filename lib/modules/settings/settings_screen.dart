import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../wallet/wallet_check_wrapper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFFFFAEA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/images/avatar.jpeg'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Lewis Jane",
                            style: TextStyle(
                              fontFamily: 'Objective',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1C2B66),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Lewis.Jane@gmail.com",
                            style: TextStyle(
                              fontFamily: 'Objective',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ).animate().fade(duration: 600.ms).slideY(begin: 0.2),

                const SizedBox(height: 30),
                _sectionTitle("Account"),
                _settingsGroup([
                  _buildSettingTile(Icons.person_outline, "My Profile", () {}),
                  _buildSettingTile(Icons.account_balance_wallet_outlined, "Wallet", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WalletCheckWrapper()),
                    );
                  }),
                  _buildSettingTile(Icons.notifications_none, "Notification", () {}),
                ]),

                const SizedBox(height: 20),
                _sectionTitle("Security"),
                _settingsGroup([
                  _buildSettingTile(Icons.lock_outline, "Change Password", () {}),
                ]),

                const SizedBox(height: 20),
                _sectionTitle("More"),
                _settingsGroup([
                  _buildSettingTile(Icons.help_outline, "FAQ", () {}),
                  _buildSettingTile(Icons.headset_mic_outlined, "Support", () {}),
                ]),

                const SizedBox(height: 30),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    // logout logic
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Color(0xFF1C2B66)),
                      SizedBox(width: 10),
                      Text(
                        "Log out",
                        style: TextStyle(
                          fontFamily: 'Objective',
                          fontSize: 16,
                          color: Color(0xFF1C2B66),
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 400.ms).moveX(begin: -30),

                const SizedBox(height: 20),

                // Delete Account
                GestureDetector(
                  onTap: () {
                    // delete account logic
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.delete_forever, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        "Delete Account",
                        style: TextStyle(
                          fontFamily: 'Objective',
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 600.ms).moveX(begin: 30),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1C2B66),
        fontFamily: 'Objective',
      ),
    ).animate().fade(duration: 300.ms);
  }

  Widget _settingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    ).animate().fade(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1C2B66), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Objective',
                  fontSize: 16,
                  color: Color(0xFF1C2B66),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
