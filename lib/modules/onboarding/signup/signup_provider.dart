import 'package:flutter/material.dart';

class SignUpProvider with ChangeNotifier {
  // User input fields
  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  // State flags
  bool isChecked = false;
  bool isLoading = false;
  String? errorMessage;

  // Update input fields
  void updateFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  void toggleCheckbox(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  // Validation logic
  bool get isFormValid {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        isChecked;
  }

  String? validateForm() {
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Please fill all fields';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    if (!isChecked) {
      return 'Please accept the terms';
    }

    return null;
  }

  // Call this on "Continue"
  Future<bool> submitForm() async {
    final error = validateForm();
    if (error != null) {
      errorMessage = error;
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Placeholder for saving to backend (if needed later)
      await Future.delayed(const Duration(milliseconds: 800)); // simulate processing

      return true;
    } catch (e) {
      errorMessage = 'Something went wrong. Try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
