// lib/modules/settings/settings_routes.dart

import 'package:flutter/material.dart';
import 'profile/profile_screen.dart';
import 'profile/edit_profile_screen.dart';
import 'profile/change_password_screen.dart';

final Map<String, WidgetBuilder> settingsRoutes = {
  '/profile': (context) => const ProfileScreen(),
  '/edit-profile': (context) => const EditProfileScreen(),
  '/change-password': (context) => const ChangePasswordScreen(),
};
