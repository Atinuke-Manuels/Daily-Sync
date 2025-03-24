import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../widgets/user_home_widgets/user_home_top_card.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ListView(
              children: [
              UserHomeTopCard(colors: colors)
                  ],),
          )),
    );
  }
}


