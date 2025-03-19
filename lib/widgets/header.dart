import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/responsive_helper.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Function()? onTap;
  final IconData? icon;

  const HeaderWidget({
    super.key,
    required this.title,
    this.subTitle,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: responsive.height(52, context),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              IconButton(
                icon: Icon(icon, color: Theme.of(context).colorScheme.inversePrimary),
                onPressed: onTap,
              ),
            Text(
              title,
              style: AppTextStyles.displayMedium(context),
              textAlign: TextAlign.center,
            ),
            SizedBox()
          ],
        ),
        if (subTitle != null) // Show subtitle only if provided
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subTitle!,
              style: AppTextStyles.bodyMedium(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
      ],
    );
  }
}
