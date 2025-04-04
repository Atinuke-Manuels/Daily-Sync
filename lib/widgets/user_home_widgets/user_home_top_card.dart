import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_text_styles.dart';
import '../../view_model/auth_view_model.dart';
import '../../view_model/user_view_model.dart';

class UserHomeTopCard extends StatefulWidget {
  const UserHomeTopCard({super.key, required this.colors});

  final ColorScheme colors;

  @override
  State<UserHomeTopCard> createState() => _UserHomeTopCardState();
}

class _UserHomeTopCardState extends State<UserHomeTopCard> {
  @override
  void initState() {
    super.initState();

    // Load user data when the widget initializes
    Future.microtask(() =>
        Provider.of<UserViewModel>(context, listen: false).loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    final AuthViewModel _authViewModel = AuthViewModel();
    ColorScheme colors = Theme.of(context).colorScheme;

    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        if (userViewModel.isLoading) {
          return Center(child: CircularProgressIndicator(color: colors.onError,));
        }

        if (userViewModel.errorMessage != null) {
          return Center(child: Text(userViewModel.errorMessage!));
        }

        final userData = userViewModel.userData;

        if (userData == null) {
          return Center(child: Text("No user data available"));
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Hello, ${userData['name'] ?? 'Guest'}", style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.w600),),
                    Text('Another bright day!', style: AppTextStyles.labelTiny(context),)
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('standup_settings').snapshots(),
                      builder: (context, snapshot) {
                        int count = snapshot.data?.docs.length ?? 0;

                        return Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/user_standup_reminder");
                              },
                              icon: Icon(Icons.notifications, color: colors.secondary, size: 20),
                            ),
                            if (count > 0)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$count',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                    ),

                  ],)
              ],
            ),
            SizedBox(height: 30,),
            Card(
              color: widget.colors.primary,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.person_pin, size: 50),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      userData['department'] ?? 'No Department',
                      style: AppTextStyles.labelSmall(context)
                          .copyWith(color: widget.colors.onError),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: colors.onError, size: 13),
                            Text('Nigeria',
                                style: AppTextStyles.bodyTiny(context)),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.circle_rounded,
                                color: colors.onTertiary, size: 5),
                            Text('Active',
                                style: AppTextStyles.bodyTiny(context)),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.circle_rounded,
                                color: colors.onTertiary, size: 5),
                            Text('Full-Time',
                                style: AppTextStyles.bodyTiny(context)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    final AuthViewModel _authViewModel = AuthViewModel();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _authViewModel.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
