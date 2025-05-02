import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OtherServicesScreen extends StatelessWidget {
  const OtherServicesScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {'title': 'Halogen Foundation', 'icon': Icons.volunteer_activism, 'color': Colors.deepPurple},
    {'title': 'Digital Investigations', 'icon': Icons.search, 'color': Colors.indigo},
    {'title': 'Threat Management', 'icon': Icons.warning, 'color': Colors.red},
    {'title': 'Embedded Security', 'icon': Icons.shield, 'color': Colors.green},
    {'title': 'Business Continuity', 'icon': Icons.business, 'color': Colors.orange},
    {'title': 'Crime/Risk Mapping', 'icon': Icons.map, 'color': Colors.teal},
    {'title': 'Private Investigations', 'icon': Icons.person_search, 'color': Colors.brown},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1C2B66)),
        title: Text(
          "Also by Halogen",
          style: TextStyle(
            fontFamily: 'Objective',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C2B66),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 5 / 2,
          ),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return _buildTile(
              icon: category['icon'],
              label: category['title'],
              iconColor: category['color'],
              delay: 100 * index,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required Color iconColor,
    int delay = 0,
  }) {
    final int adjustedAlpha = (iconColor.a * 0.1).round();

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to detail screen
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 5,
              offset: Offset(0, 3),
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
      ).animate(delay: delay.ms).fade(duration: 500.ms).scale(duration: 400.ms),
    );
  }
}
