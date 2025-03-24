import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/form_validation.dart';
import '../../view_model/auth_view_model.dart';
import '../../widgets/show_alert.dart';
import '../core/models/user_model.dart';
import '../core/provider/user_provider.dart';

class LoginViewModel with ChangeNotifier {
  final AuthViewModel _authViewModel;

  LoginViewModel(this._authViewModel);

  /// Handles the user creation process
  /// Handles the user login process
  Future<void> logUserIn(Map<String, String> formData, BuildContext context) async {
    String email = formData['Email Address']!.trim();
    String password = formData['Password']!.trim();

    try {
      UserModel? user = await _authViewModel.signIn(email, password);

      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUserId(user.id);
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


    // String? passwordError = validatePassword(password);
    // if (passwordError != null) return passwordError;


    return null;
  }


}