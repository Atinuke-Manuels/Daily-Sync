import 'package:daily_sync/theme/app_theme.dart';
import 'package:daily_sync/view_model/auth_view_model.dart';
import 'package:daily_sync/view_model/user_view_model.dart';
import 'package:daily_sync/views/auth/forgot_password_screen.dart';
import 'package:daily_sync/views/auth/login_screen.dart';
import 'package:daily_sync/views/auth/signup_screen.dart';
import 'package:daily_sync/views/auth/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/utils/responsive_helper.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize OneSignal
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose); // For debugging
  OneSignal.initialize(dotenv.env['ONE_SIGNAL_APP_ID']!); // Replace with your App ID
  OneSignal.Notifications.requestPermission(true); // Request notification permissions


  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => ResponsiveHelper(designWidth: 390, designHeight: 844),
        ),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Sync',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/signup': (context) => SignupScreen(),
        '/login' : (context) => LoginScreen(),
        '/forgotPassword' : (context) => ForgotPasswordScreen()
      },
    );
  }
}


