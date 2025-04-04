
import 'package:daily_sync/views/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import '../views/admin/admin_dashboard.dart'; // Import AdminDashboard

class AppRoutes {

  static const String splashScreen = '/splashScreen';
  static const String adminDashboard = '/admin-dashboard';

  static final Map<String, Widget Function(BuildContext, dynamic)> _routeBuilders = {
    splashScreen: (context, args) => SplashScreen(),
    adminDashboard: (context, args) {
      final String? adminId = args as String?;
      if (adminId == null || adminId.isEmpty) {
        return SplashScreen(); // Redirect to login if no adminId
      }
      return AdminDashboard(); // Navigate to AdminDashboard
    },
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = _routeBuilders[settings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: (context) => builder(context, settings.arguments),
      );
    }

    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text("Page not found")),
      ),
    );
  }
}
