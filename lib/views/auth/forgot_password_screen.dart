import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:daily_sync/widgets/bottom_text.dart';
import 'package:flutter/material.dart';

import '../../core/data/form_data.dart';
import '../../view_model/forgot_password_view_model.dart';
import '../../widgets/dynamic_signup_form.dart';
import '../../widgets/header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordViewModel _viewModel = ForgotPasswordViewModel();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        HeaderWidget(
                          title: 'Forgot Password?',
                          subTitle: 'Enter your registered email address',
                          icon: Icons.arrow_back,
                          onTap: (){},
                        ),
                        SizedBox(height: 20,),
                        DynamicForm(dynamicFields: forgotPasswordFormFieldList, onSubmit: _sendResetEmail,),
                      ],
                    ),
                    BottomText(title: "Remember your password?", subString: 'Login', onPress: ()=> Navigator.pushNamed(context, '/login'),)
                  ],
                )
              ],
            ),
          )),
    );
  }

  void _sendResetEmail(Map<String, String> formData) async {
    String email = formData['Email Address']!.trim();

    await _viewModel.sendPasswordResetEmail(email, context);
    Navigator.pushNamed(context, '/login');
  }

}
