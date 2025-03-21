import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:daily_sync/widgets/bottom_text.dart';
import 'package:flutter/material.dart';

import '../../core/data/form_data.dart';
import '../../widgets/dynamic_signup_form.dart';
import '../../widgets/header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


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
                          title: 'Welcome back!',
                          subTitle: 'Login to your account',
                          icon: Icons.arrow_back,
                          onTap: (){},
                        ),
                        SizedBox(height: 20,),
                        DynamicForm(dynamicFields: loginFormFieldList, onSubmit: _loginUser,),
                        TextButton(onPressed: (){
                          Navigator.pushNamed(context, '/forgotPassword');
                        }, child: Text('forgot Password?', style: AppTextStyles.bodySmall(context),)),
                      ],
                    ),
                    BottomText(title: "Don't Have An Account?", subString: 'Signup', onPress: ()=> Navigator.pushNamed(context, '/signup'),)
                  ],
                )
              ],
            ),
          )),
    );
  }

  void _loginUser(Map<String, String> formData){}
}
