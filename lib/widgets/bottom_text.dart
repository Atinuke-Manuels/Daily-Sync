import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';


class BottomText extends StatelessWidget {
  final String title;
  final String subString;
  final Function() onPress;
  const BottomText({super.key, required this.title, required this.subString, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(title,
        style: AppTextStyles.bodyMedium(context),
      ),
      TextButton(
      onPressed: onPress,
      child:Text(subString, style: AppTextStyles.bodyMedium(context).copyWith(
      fontWeight: FontWeight.w600
      ),),

      )
        ],
      ),
    );
  }
}
