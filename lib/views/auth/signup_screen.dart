import 'package:daily_sync/widgets/bottom_text.dart';
import 'package:daily_sync/widgets/custom_button.dart';
import 'package:daily_sync/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../../core/data/form_data.dart';
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
            SizedBox(height: 20,),
            DynamicForm(dynamicFields: signupFormFieldList, onSubmit: (){
              Navigator.pushNamed(context, '/login');
            },),
            BottomText(title: 'Have an Account?', subString: 'Login', onPress: ()=> Navigator.pushNamed(context, '/login'))
          ],
        ),
      )),
    );
  }
}
