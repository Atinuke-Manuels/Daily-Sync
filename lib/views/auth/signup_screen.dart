import 'package:daily_sync/widgets/bottom_text.dart';
import 'package:daily_sync/widgets/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/form_data.dart';
import '../../core/utils/form_validation.dart';
import '../../view_model/auth_view_model.dart';
import '../../widgets/dynamic_signup_form.dart';
import '../../widgets/header.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            HeaderWidget(
              title: 'Create An Account',
              subTitle: 'Create an account and gain access to our features',
            ),
            SizedBox(
              height: 20,
            ),
            DynamicForm(
              dynamicFields: signupFormFieldList,
              onSubmit: _registerUser,
            ),
            BottomText(
                title: 'Have an Account?',
                subString: 'Login',
                onPress: () => Navigator.pushNamed(context, '/login'))
          ],
        ),
      )),
    );
  }

  void _registerUser(Map<String, String> formData) async {
    String? validationError = _validateForm(formData);

    if (validationError != null) {
      ShowMessage().showErrorMsg(validationError, context);
      return;
    }

    await _createUser(formData);
  }

  /// Validates form data and returns an error message if validation fails
  String? _validateForm(Map<String, String> formData) {
    String name = formData['Name']?.trim() ?? "";
    String email = formData['Email Address']?.trim() ?? "";
    String password = formData['Password']?.trim() ?? "";
    String confirmPassword = formData['Confirm Password']?.trim() ?? "";
    String department = formData['Select Department']?.trim() ?? ""; // Ensure the key matches the dropdown label

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
  Future<void> _createUser(Map<String, String> formData) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    String email = formData['Email']!.trim();
    String password = formData['Password']!.trim();
    String name = formData['Name']!.trim();
    String department = formData['Department']!.trim();

    try {
      bool isSuccess = await authViewModel.signUp(email, password, name, department, "User");

      if (isSuccess) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ShowMessage().showErrorMsg("Signup failed. Please try again.", context);
      }
    } catch (e) {
      ShowMessage().showErrorMsg("Error: ${e.toString()}", context);
    }
  }


}
