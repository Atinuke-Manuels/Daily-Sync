import 'package:daily_sync/widgets/daily_standup_report_widgets/daily_standup_reminder.dart';
import 'package:daily_sync/widgets/standup_reminder_widget/standup_reminder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_view_model.dart';
import '../../widgets/add_user_widgets/add_team_member.dart';
import '../../widgets/add_user_widgets/view_team_members.dart';
import '../../widgets/daily_standup_report_widgets/daily_standup.dart';
import '../../widgets/schedule_daily_standup/standup_schedule_screen.dart';
import '../../widgets/share_updates_widget/share_updates.dart';



class AdminDashboard extends StatefulWidget {
  final String adminId;

  const AdminDashboard({super.key, required this.adminId});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();

    // Load user data when the widget initializes
    Future.microtask(() =>
        Provider.of<UserViewModel>(context, listen: false).loadUserData());
  }


  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          if (userViewModel.isLoading) {
            return Center(
                child: CircularProgressIndicator(color: colors.onError,));
          }

          if (userViewModel.errorMessage != null) {
            return Center(child: Text(userViewModel.errorMessage!));
          }

          final userData = userViewModel.userData;

          if (userData == null) {
            return Center(child: Text("No user data available"));
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ("Hello, ${userData['name'] ?? 'Admin'}"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF030F2D),
                    ),
                  ),
                ],
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Color(0xFF030F2D)),
                      onPressed: () {},
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              reverse: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Schedule Daily Standup Card with Stroke and Increased Height
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                            color: Colors.white, width: 2), // Stroke added
                      ),
                      color: Color(0xFF030F2D),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 50, horizontal: 14), // Increased height
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => StandupScheduleScreen()),
                                );
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: Colors.white,
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.add, color: Color(0xFF030F2D),
                                      size: 26),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => StandupScheduleScreen()),
                                );
                              },
                              child: const Text(
                                'Schedule Daily Standup',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Features Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Features",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF030F2D),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewTeamMembers()),
                            );
                          },
                          child: const Text(
                            "Team Members",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF030F2D),
                              decorationThickness: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildFeatureCard(
                        context, 'Daily Standup Reminder', Icons.access_time),
                    _buildFeatureCard(context, 'Add Team Members', Icons.group_add),
                    _buildFeatureCard(
                        context, 'View Daily Standup Report', Icons.article),
                    _buildFeatureCard(context, 'Share Updates', Icons.share),
                  ],
                ),
              ),
            ),
          );
        });


  }

  // Feature Card Widget
  Widget _buildFeatureCard(BuildContext context, String title, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (title == 'Add Team Members') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTeamMember()),
            );
          } else if (title == 'Daily Standup Reminder') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DailyStandupReminder()), // Define this screen
            );
          } else if (title == 'View Daily Standup Report') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DailyStandup()), // Define this screen
            );
          } else if (title == 'Share Updates') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShareUpdates()), // Define this screen
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title clicked, but no screen assigned')),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListTile(
            leading: Icon(icon, size: 30, color: Color(0xFF030F2D)),
            title: Text(
              title,
              style: const TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
