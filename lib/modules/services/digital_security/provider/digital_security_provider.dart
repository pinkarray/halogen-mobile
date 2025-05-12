import 'package:flutter/material.dart';

class DigitalSecurityProvider extends ChangeNotifier {
  final Map<String, dynamic> _sectionDetails = {};
  final Map<String, bool> _completedSections = {
    'surveillance': false,
    'anti_surveillance': false,
    'digital_protection': false,
  };

  Map<String, dynamic> get allSectionDetails => _sectionDetails;

  void updateSectionDetails(String key, Map<String, dynamic> data) {
    _sectionDetails[key] = data;
    _completedSections[key] = true;
    notifyListeners();
  }

  void markSectionComplete(String key) {
    _completedSections[key] = true;
    notifyListeners();
  }

  bool isSectionComplete(String key) => _completedSections[key] ?? false;

  bool get isAnyServiceSelected =>
      _completedSections.values.any((completed) => completed);

  void reset() {
    _sectionDetails.clear();
    _completedSections.updateAll((key, value) => false);
    notifyListeners();
  }
}
