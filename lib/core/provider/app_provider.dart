import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth_view_model.dart';
import '../../view_model/login_view_model.dart';
import '../../view_model/signup_view_model.dart';
import '../../view_model/user_view_model.dart';
import '../utils/responsive_helper.dart';


List<Widget> appProviders = [
  Provider(
    create: (_) => ResponsiveHelper(designWidth: 390, designHeight: 844),
  ),
  ChangeNotifierProvider(create: (_) => AuthViewModel()),
  ChangeNotifierProvider(create: (_) => UserViewModel()),
  ChangeNotifierProxyProvider<AuthViewModel, SignupViewModel>(
    create: (_) => SignupViewModel(AuthViewModel()),
    update: (_, authViewModel, signupViewModel) =>
        SignupViewModel(authViewModel),
  ),
  ChangeNotifierProxyProvider<AuthViewModel, LoginViewModel>(
    create: (_) => LoginViewModel(AuthViewModel()),
    update: (_, authViewModel, loginViewModel) =>
        LoginViewModel(authViewModel),
  ),
];
