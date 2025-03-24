import 'package:daily_sync/widgets/bottom_text.dart';
import 'package:daily_sync/widgets/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/form_data.dart';
import '../../view_model/signup_view_model.dart'; // Import the new ViewModel
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
                title: 'Create A User Account',
                subTitle: 'Create an account and gain access to our features',
              ),
              const SizedBox(height: 20),
              DynamicForm(
                dynamicFields: signupFormFieldList,
                onSubmit: _registerUser,
              ),
              BottomText(
                title: 'Have an Account?',
                subString: 'Login',
                onPress: () => Navigator.pushNamed(context, '/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser(Map<String, String> formData) async {
    final signupViewModel = Provider.of<SignupViewModel>(context, listen: false);

    // Validate form data
    String? validationError = signupViewModel.validateForm(formData);
    if (validationError != null) {
      ShowMessage().showErrorMsg(validationError, context);
      return;
    }

    // Create user
    await signupViewModel.createUser(formData, context);
  }
}