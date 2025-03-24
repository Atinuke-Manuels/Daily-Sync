import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/utils/responsive_helper.dart'; // Import ResponsiveHelper

class AppTextStyles {
  static TextStyle displayLarge(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
      fontSize: responsive.fontSize(24, context),
      fontWeight: FontWeight.w800,
      color: Color(0xFF030F2D),
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
      fontSize: responsive.fontSize(20, context),
      fontWeight: FontWeight.w600,
      color: Color(0xFF030F2D),
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
      fontSize: responsive.fontSize(14, context),
      fontWeight: FontWeight.w600,
      color: Color(0xFF030F2D),
    );
  }

  static TextStyle displayTiny(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
        fontSize: responsive.fontSize(10, context),
        color: Color(0xFF9F9F9F),
        fontWeight: FontWeight.w400
    );

  }

  static TextStyle bodyLarge(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
      fontSize: responsive.fontSize(16, context),
      color: Colors.black87,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
      fontSize: responsive.fontSize(16, context),
      fontWeight: FontWeight.w400,
      color: Color(0xFF030F2D),
    );
  }
  static TextStyle bodySmall(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
      fontSize: responsive.fontSize(14, context),
      fontWeight: FontWeight.w400,
      color: Color(0xFF030F2D),
    );
  }

  static TextStyle bodyTiny(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
        fontSize: responsive.fontSize(10, context),
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w400
    );

  }

  static TextStyle labelMedium(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
      fontSize: responsive.fontSize(16, context),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
      fontSize: responsive.fontSize(14, context),
      color: Color(0xFF2F2F2F),
      fontWeight: FontWeight.w500
    );

  }

  static TextStyle labelTiny(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return TextStyle(
        fontSize: responsive.fontSize(12, context),
        color: Color(0xFF030F2D),
        fontWeight: FontWeight.w500
    );

  }
}
