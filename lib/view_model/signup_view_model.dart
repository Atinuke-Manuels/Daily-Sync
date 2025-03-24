import 'package:flutter/material.dart';

import '../../core/utils/form_validation.dart';
import '../../view_model/auth_view_model.dart';
import '../../widgets/show_alert.dart';
import '../core/models/user_model.dart';

class SignupViewModel with ChangeNotifier {
  final AuthViewModel _authViewModel;

  SignupViewModel(this._authViewModel);

  /// Validates form data and returns an error message if validation fails
  String? validateForm(Map<String, String> formData) {
    String name = formData['Name']?.trim() ?? "";
    String email = formData['Email Address']?.trim() ?? "";
    String password = formData['Password']?.trim() ?? "";
    String confirmPassword = formData['Confirm Password']?.trim() ?? "";
    String department = formData['Select Department']?.trim() ?? "";

    // Check for empty required fields first
    if (name.isEmpty) return "Name is required.";
    if (email.isEmpty) return "Email is required.";
    if (department.isEmpty) return "Select a department.";
    if (password.isEmpty) return "Password is required.";
    if (confirmPassword.isEmpty) return "Confirm password is required.";

    // Validate name, email, and password format
    String? nameError = validateName(name);
    if (nameError != null) return nameError;

    String? emailError = validateEmail(email);
    if (emailError != null) return emailError;

    String? departmentError = validateDepartment(department);
    if (departmentError != null) return departmentError;

    String? passwordError = validatePassword(password);
    if (passwordError != null) return passwordError;

    // Check if passwords match
    if (password != confirmPassword) return "Passwords do not match.";

    return null;
  }

  /// Handles the user creation process
  Future<void> createUser(Map<String, String> formData, BuildContext context) async {
    String email = formData['Email Address']!.trim();
    String password = formData['Password']!.trim();
    String name = formData['Name']!.trim();
    String department = formData['Select Department']!.trim();

    try {
      UserModel? user = await _authViewModel.signUp(email, password, name, "User", department);

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ShowMessage().showErrorMsg(e.toString().replaceFirst('Exception: ', ''), context);
    }
  }


}