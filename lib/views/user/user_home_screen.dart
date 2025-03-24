import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:daily_sync/widgets/custom_button.dart';
import 'package:daily_sync/widgets/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/provider/user_provider.dart';
import '../../core/services/standup_service.dart';
import '../../view_model/auth_view_model.dart';
import '../../widgets/user_home_widgets/custom_standup_text_field.dart';
import '../../widgets/user_home_widgets/user_home_top_card.dart';
import 'daily_standup_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {


  final StandupService _standupService = StandupService();

  final TextEditingController _yesterdayController = TextEditingController();
  final TextEditingController _todayController = TextEditingController();
  final TextEditingController _blockersController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserProvider>(context).userId;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Makes the entire page scrollable
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserHomeTopCard(colors: colors), // Will now scroll with the page
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Submit your standup report for today',
                      style: AppTextStyles.displayTiny(context).copyWith(color: colors.primary, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyDailyStandupReportsScreen()),
                        );
                      },
                      child: Center(
                        child: Text(
                          "View My Reports",
                          style: AppTextStyles.bodyTiny(context).copyWith(color: colors.onTertiary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomStandUpTextField(
                  yesterdayController: _yesterdayController,
                  title: "Yesterday's Task",
                ),
                CustomStandUpTextField(
                  yesterdayController: _todayController,
                  title: "Today's Task",
                ),
                CustomStandUpTextField(
                  yesterdayController: _blockersController,
                  title: "Any Blockers?",
                ),
                const SizedBox(height: 20),
                CustomButton( onTap: () {
          _submitStandup();
          }, title: "Submit Standup"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> _submitStandup() async {
    String userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (_yesterdayController.text.trim().isEmpty ||
        _todayController.text.trim().isEmpty ||
        _blockersController.text.trim().isEmpty) {
      ShowMessage().showErrorMsg("Please fill in all fields before submitting.", context);
      return;
    }

    try {
      bool canSubmit = await _standupService.canSubmitStandup(userId);

      if (!canSubmit) {
        ShowMessage().showErrorMsg("You can only submit one standup update per day.", context);
        return;
      }

      await _standupService.submitStandup(
        userId,
        {
          "yesterday": _yesterdayController.text.trim(),
          "today": _todayController.text.trim(),
          "blockers": _blockersController.text.trim(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Standup submitted successfully!")),
      );

      _yesterdayController.clear();
      _todayController.clear();
      _blockersController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

}




