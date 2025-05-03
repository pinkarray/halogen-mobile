import 'package:flutter/material.dart';
import 'bounce_tap.dart';
import 'package:halogen/screens/dashboard_screen.dart';
import 'package:halogen/screens/services_screen.dart';
import 'package:halogen/screens/profile_screen.dart';
import 'package:halogen/screens/monitoring_services_screen.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    DashboardScreen(),
    ServicesScreen(),
    MonitoringServicesScreen(),
    ProfileScreen(),
  ];

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );
    _animations = _controllers.map((controller) {
      return TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
      ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    }).toList();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    _controllers[index].forward(from: 0.0);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFFCC29),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: List.generate(4, (index) {
          final iconData = [
            Icons.dashboard, // Dashboard
            Icons.shield_outlined, // Services
            Icons.videocam_outlined, // Monitoring
            Icons.settings_outlined, // Settings
          ][index];

          final label = ["Dashboard", "Services", "Monitoring", "Settings"][index];

          return BottomNavigationBarItem(
            icon: BounceTap(
              onTap: () => _onItemTapped(index),
              child: ScaleTransition(
                scale: _animations[index],
                child: Icon(iconData),
              ),
            ),
            label: label,
          );
        }),
      ),
    );
  }
}
