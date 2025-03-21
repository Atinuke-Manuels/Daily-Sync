import 'package:flutter/material.dart';


ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    colorScheme: ColorScheme.light(
        surface: Color(0xFFEBEBEB),
        primary: Color(0xFF092C4C),
        onPrimary: Colors.white,
        inversePrimary: Color(0xFF030F2D), // text color
        inverseSurface: Color(0xFFC1C0C0), // textField border color
        secondary: Color(0xFF6A6A6A),
        error: Colors.red,
        onError: Color(0xFFFFFFFF)
    ),
);
