import 'package:daily_sync/theme/app_theme.dart';
import 'package:daily_sync/view_model/auth_view_model.dart';
import 'package:daily_sync/view_model/login_view_model.dart';
import 'package:daily_sync/view_model/signup_view_model.dart';
import 'package:daily_sync/view_model/user_view_model.dart';
import 'package:daily_sync/views/admin/admin_dashboard.dart';
import 'package:daily_sync/views/auth/forgot_password_screen.dart';
import 'package:daily_sync/views/auth/login_screen.dart';
import 'package:daily_sync/views/auth/signup_screen.dart';
import 'package:daily_sync/views/auth/splash_screen.dart';
import 'package:daily_sync/views/user/bottom_nav_screen.dart';
import 'package:daily_sync/views/user/user_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/provider/user_provider.dart';
import 'core/utils/responsive_helper.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => ResponsiveHelper(designWidth: 390, designHeight: 844),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => UserProvider(),),
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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeOneSignal();
  }

  void _initializeOneSignal() {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose); // Debugging
    OneSignal.initialize(dotenv.env['ONE_SIGNAL_APP_ID']!);
    OneSignal.Notifications.requestPermission(true);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Sync',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      initialRoute: '/adminDashboard',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/signup': (context) => SignupScreen(),
        '/login' : (context) => LoginScreen(),
        '/forgotPassword' : (context) => ForgotPasswordScreen(),
        '/userBottomNav' : (context) => UserBottomNavBar(),
        '/userHomeScreen' : (context) => UserHomeScreen(),
        '/adminDashboard': (context) => AdminDashboard(adminId: '',),
      },
    );
  }
}


