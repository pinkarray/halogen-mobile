import 'package:flutter/foundation.dart';

class UserFormDataProvider extends ChangeNotifier {
  Map<String, dynamic> _sections = {};

  bool stage2Completed = false;
  bool stage3Completed = false;
  bool isFullyRegistered = false;

  Map<String, dynamic> get allSections => _sections;

  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _password;
  String? _confirmationId;

  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get password => _password;
  String? get confirmationId => _confirmationId;

  void updateOnboardingInfo({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
  }) {
    if (fullName != null) _fullName = fullName;
    if (email != null) _email = email;
    if (phoneNumber != null) _phoneNumber = phoneNumber;
    if (password != null) _password = password;
    notifyListeners();
  }

  void saveConfirmationId(String id) {
    _confirmationId = id;
    notifyListeners();
  }

  void resetOnboardingInfo() {
    _fullName = null;
    _email = null;
    _phoneNumber = null;
    _password = null;
    _confirmationId = null;
    notifyListeners();
  }

  void markFullyRegistered() {
    isFullyRegistered = true;
    notifyListeners();
  }

  void updateSection(String sectionKey, Map<String, dynamic> values) {
    _sections[sectionKey] = values;
    notifyListeners();
  }

  void reset() {
    _sections.clear();
    notifyListeners();
  }

  Map<String, dynamic> toJson() => _sections;

  void loadFromJson(Map<String, dynamic> json) {
    _sections = json;
    notifyListeners();
  }

  int getCurrentMobilityStage() {
    return _sections['secured_mobility']?['currentStage'] ?? 1;
  }

  int _currentSignUpStep = 1; 

  int get currentSignUpStep => _currentSignUpStep;

  void updateSignUpStep(int step) {
    _currentSignUpStep = step;
    notifyListeners();
  }

  int getCurrentOutsourcingStage() {
    return (_sections['outsourcing_talent']?['current_stage'] ?? 1) as int;
  }

  double stage1ProgressPercent = 0.0;

  void updateStage1Progress(double percent) {
    stage1ProgressPercent = percent;
    notifyListeners();
  }

  void calculateOutsourcingProgress() {
    final desiredServices = allSections['outsourcing_talent']?['desired_services'] ?? {};

    int completedCount = 0;
    if (desiredServices['domestic_staff']?['completed'] == true) completedCount++;
    if (desiredServices['business_staff']?['completed'] == true) completedCount++;
    if (desiredServices['background_checks']?['completed'] == true) completedCount++;
    if (desiredServices['investigation']?['completed'] == true) completedCount++;
    if (desiredServices['lea_liaison']?['completed'] == true) completedCount++;

    double newPercent = completedCount / 5;

    updateStage1Progress(newPercent);

    if (completedCount == 5) {
      allSections['outsourcing_talent'] = {
        ...allSections['outsourcing_talent'],
        'current_stage': 2,
      };
      notifyListeners();
    }
  }

  void updateMobilityStage(int newStage) {
    if (_sections['secured_mobility'] == null) {
      _sections['secured_mobility'] = {};
    }

    _sections['secured_mobility']['currentStage'] = newStage;
    notifyListeners();
  }

    void markStage2Completed() {
    stage2Completed = true;
    notifyListeners();
  }

  void markStage3Completed() {
    stage3Completed = true;
    notifyListeners();
  }

}
