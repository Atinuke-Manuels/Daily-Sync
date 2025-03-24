import 'package:flutter/widgets.dart';

class ResponsiveHelper{
  final double designWidth;
  final double designHeight;

  ResponsiveHelper({required this.designWidth, required this.designHeight});

  /// Converts height based on the design screen height
  double height(double inputHeight, BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (inputHeight / designHeight) * screenHeight;
  }

  /// Converts width based on the design screen width
  double width(double inputWidth, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (inputWidth / designWidth) * screenWidth;
  }

  /// Converts font size based on the design screen width
  double fontSize(double inputFontSize, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (inputFontSize / designWidth) * screenWidth;
  }

  /// Converts height to a percentage of the screen height
  double heightPercentage(double inputHeight, BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (inputHeight / designHeight) * 100;
  }

  /// Converts width to a percentage of the screen width
  double widthPercentage(double inputWidth, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (inputWidth / designWidth) * 100;
  }
}


// Usage app wide - using provider

// add package
// flutter pub add provider

// initialise in main.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'responsive_helper.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         Provider(
//           create: (context) => ResponsiveHelper(designWidth: 375, designHeight: 812),
//         ),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }


// Sample usage
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'responsive_helper.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
//
//     return Scaffold(
//       body: Center(
//         child: Container(
//           height: responsive.height(40, context),
//           width: responsive.width(100, context),
//           color: Colors.blue,
//           child: Text(
//             "Responsive Text",
//             style: TextStyle(fontSize: responsive.fontSize(16, context)),
//           ),
//         ),
//       ),
//     );
//   }
// }
