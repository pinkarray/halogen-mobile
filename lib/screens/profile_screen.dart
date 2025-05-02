import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dashboard_screen.dart';
import 'services_screen.dart';
import 'physical_security_screen.dart';
import 'digital_security_screen.dart';
import 'people_risk_screen.dart';
import 'secured_mobility_screen.dart';
import 'other_services_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Profile Header with Border and Shadow
            Padding(
              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/profile.jpeg"),
                    ),
                  ).animate().fade(duration: 800.ms).scale(duration: 600.ms),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Objective',
                          color: Color(0xFF1C2B66),
                        ),
                      ),
                      Text(
                        "Premium Member",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Objective',
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            // ✅ Grid of Service Tiles (Left-Aligned with Colorful Icons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 5 / 2,
                children: [
                  _buildServiceTile(Icons.security, "Physical Security", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PhysicalSecurityScreen()),
                    );
                  }, Colors.deepPurple),
                  _buildServiceTile(Icons.directions_car, "Secured Mobility", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecuredMobilityScreen()),
                    );
                  }, Colors.orange),
                  _buildServiceTile(Icons.privacy_tip, "Digital Security", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DigitalSecurityScreen()),
                    );
                  }, Colors.indigo),
                  _buildServiceTile(Icons.people, "People Risk Mgmt", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PeopleRiskScreen()),
                    );
                  }, Colors.green),
                  _buildServiceTile(Icons.grid_view, "Also by Halogen", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtherServicesScreen()),
                    );
                  }, Colors.teal),
                ],
              ),
            ),

            SizedBox(height: 30),

            // ✅ Settings List
            _buildProfileOption(
              icon: Icons.security,
              title: "Security Settings",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.notifications,
              title: "Notifications",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.payment,
              title: "Subscription & Billing",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.support_agent,
              title: "Help & Support",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.settings,
              title: "App Settings",
              onTap: () {},
            ),

            SizedBox(height: 30),

            // ✅ Logout
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFCC29),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 10),
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Objective',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 1200.ms).scale(duration: 700.ms),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Color(0xFFFFCC29),
        unselectedItemColor: Color(0xFF1C2B66),
        backgroundColor: Colors.white,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ServicesScreen()));
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildServiceTile(IconData icon, String label, VoidCallback onTap, Color iconColor) {
    final int adjustedAlpha = (iconColor.alpha * 0.1).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromARGB(
                  adjustedAlpha,
                  iconColor.red,
                  iconColor.green,
                  iconColor.blue,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Objective',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1C2B66),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).toInt()),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF1C2B66)),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Objective',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C2B66),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}