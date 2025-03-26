import 'package:flutter/material.dart';

class StandUpReportText extends StatelessWidget {
  final String title;
  final String subTitle;
  const StandUpReportText({
    super.key,
    required this.title,
    required this.subTitle,
  });



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: subTitle,
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        SizedBox(height: 14),
      ],
    );
  }
}