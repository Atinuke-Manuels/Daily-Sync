import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/responsive_helper.dart';
import '../theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  final Color? btnColor ;


  const CustomButton({super.key, required this.onTap, required this.title, this.btnColor});
  @override
  Widget build(BuildContext context) {
    final Color buttonColor = btnColor ?? Theme.of(context).colorScheme.inversePrimary;

    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Container(
          width: responsive.width(342, context),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(30)
          ),
          child:  Center(child: Text(title, style: AppTextStyles.labelMedium(context)))
        ),
      ),
    );
  }
}
