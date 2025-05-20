import 'package:flutter/material.dart';
import 'package:halogen/shared/helpers/session_manager.dart';

class ProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;

  bool get isLoaded => _user != null;

  Future<void> loadUser() async {
    final profile = await SessionManager.getUserProfile();
    _user = profile;
    notifyListeners();
  }

  void updateField(String key, dynamic value) {
    if (_user != null) {
      _user![key] = value;
      notifyListeners();
    }
  }

  void setUser(Map<String, dynamic> newUser) {
    _user = newUser;
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}
