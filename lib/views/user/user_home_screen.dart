import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ListView(children: [
                    Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Hello, Queen", style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.w600),),
                  Text('Another bright day!', style: AppTextStyles.labelTiny(context),)
                ],
              ),
              Icon(Icons.notifications, color: colors.secondary, size: 20,)
            ],
                    ),
              SizedBox(height: 30,),
              UserHomeTopCard(colors: colors)
                  ],),
          )),
    );
  }
}

class UserHomeTopCard extends StatelessWidget {
  const UserHomeTopCard({
    super.key,
    required this.colors,
  });

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors.primary,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            CircleAvatar(child: Icon(Icons.person_pin, size: 50,),),
            Text('Mobile Developer', style: AppTextStyles.labelSmall(context).copyWith(color: colors.onError),),
            Row(
              spacing: 14,
              children: [
              Row(
                spacing: 4,
                children: [
                Icon(Icons.location_on_outlined, color: colors.onError, size: 13,),
                Text('Nigeria', style: AppTextStyles.bodyTiny(context),)
              ],),
              Row(
                spacing: 4,
                children: [
                Icon(Icons.circle_rounded, color: colors.onTertiary, size: 5,),
                Text('Active', style: AppTextStyles.bodyTiny(context),)
              ],),

              Row(
                spacing: 4,
                children: [
                Icon(Icons.circle_rounded, color: colors.onTertiary, size: 5,),
                Text('Full-Time', style: AppTextStyles.bodyTiny(context),)
              ],),
            ],)
          ],
        ),
      ),
    );
  }
}
