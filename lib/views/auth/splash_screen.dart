import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:daily_sync/views/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/responsive_helper.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
        context,
        '/signup',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_screen_image.png', width: responsive.width(350, context), height: 350,), // Your logo
            const SizedBox(height: 18),
            Text(
              "Daily Sync",
              style: AppTextStyles.displayLarge(context),
            ),
          ],
        ),
      ),
    );
  }
}
