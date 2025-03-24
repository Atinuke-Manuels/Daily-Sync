import 'package:flutter/material.dart';

import '../../core/utils/form_validation.dart';
import '../../view_model/auth_view_model.dart';
import '../../widgets/show_alert.dart';
import '../core/models/user_model.dart';

class LoginViewModel with ChangeNotifier {
  final AuthViewModel _authViewModel;

  LoginViewModel(this._authViewModel);

  /// Handles the user creation process
  Future<void> logeUserIn(Map<String, String> formData, BuildContext context) async {
    String email = formData['Email Address']!.trim();
    String password = formData['Password']!.trim();

    try {
      UserModel? user = await _authViewModel.signIn(email, password);

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/userBottomNav');
      }
    } catch (e) {
      ShowMessage().showErrorMsg(e.toString().replaceFirst('Exception: ', ''), context);
    }
  }


  /// Validates form data and returns an error message if validation fails
  String? validateForm(Map<String, String> formData) {

    String email = formData['Email Address']?.trim() ?? "";
    String password = formData['Password']?.trim() ?? "";


    // Check for empty required fields first
    if (email.isEmpty) return "Email is required.";
    if (password.isEmpty) return "Password is required.";



    String? emailError = validateEmail(email);
    if (emailError != null) return emailError;


    String? passwordError = validatePassword(password);
    if (passwordError != null) return passwordError;


    return null;
  }


}