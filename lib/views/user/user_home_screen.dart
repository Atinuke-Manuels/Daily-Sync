import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:daily_sync/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/provider/user_provider.dart';
import '../../core/services/standup_service.dart';
import '../../view_model/auth_view_model.dart';
import '../../widgets/user_home_widgets/custom_standup_text_field.dart';
import '../../widgets/user_home_widgets/user_home_top_card.dart';

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
                Text(
                  'Submit your standup report for today',
                  style: AppTextStyles.displaySmall(context),
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
                CustomButton(onTap: _submitStandup, title: "Submit Standup"),
                const SizedBox(height: 20),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('standups')
                      .where('userId', isEqualTo: userId)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text("No Standup Update Available"));
                    }

                    var standups = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true, // Prevents ListView from taking infinite height
                      physics: const NeverScrollableScrollPhysics(), // Disables internal scrolling
                      itemCount: standups.length,
                      itemBuilder: (context, index) {
                        var standup = standups[index];
                        var data = standup.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Yesterday: ${data['yesterday']}"),
                              Text("Today: ${data['today']}"),
                              Text("Blockers: ${data['blockers']}"),
                            ],
                          ),
                          subtitle: Text("Submitted at: ${data['createdAt'].toDate()}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editStandup(standup.id, data),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteStandup(standup.id, data['createdAt']),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> _submitStandup() async {
    String userId = Provider.of<UserProvider>(context).userId;
    if (_yesterdayController.text.trim().isEmpty ||
        _todayController.text.trim().isEmpty ||
        _blockersController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields before submitting.")),
      );
      return;
    }

    try {
      bool canSubmit = await _standupService.canSubmitStandup(userId);

      if (!canSubmit) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You can only submit one standup update per day.")),
        );
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


  Future<void> _deleteStandup(String docId, Timestamp createdAt) async {
    if (_standupService.canEditOrDelete(createdAt)) {
      await FirebaseFirestore.instance.collection('standups').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Standup deleted!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only delete within 1 hour of submission.")),
      );
    }
  }

  Future<void> _editStandup(String docId, Map<String, dynamic> data) async {
    _yesterdayController.text = data['yesterday'];
    _todayController.text = data['today'];
    _blockersController.text = data['blockers'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Standup"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _yesterdayController,
              decoration: const InputDecoration(labelText: "What I Did Yesterday"),
            ),
            TextField(
              controller: _todayController,
              decoration: const InputDecoration(labelText: "What I Will Do Today"),
            ),
            TextField(
              controller: _blockersController,
              decoration: const InputDecoration(labelText: "Blockers/Challenges"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_standupService.canEditOrDelete(data['createdAt'])) {
                await FirebaseFirestore.instance.collection('standups').doc(docId).update({
                  "yesterday": _yesterdayController.text,
                  "today": _todayController.text,
                  "blockers": _blockersController.text,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Standup updated successfully!")),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You can only edit within 1 hour of submission.")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}




