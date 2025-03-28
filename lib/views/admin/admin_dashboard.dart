import 'package:flutter/material.dart';

import '../../widgets/add_user_widgets/add_team_member.dart';



class AdminDashboard extends StatelessWidget {
  final String adminId;

  const AdminDashboard({super.key, required this.adminId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(width: 8),
            const Text(
              "Hello, Admin",
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
      body: Padding(
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
                        // Add action here
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
                    const Text(
                      'Schedule Daily Standup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Features Section
            const Text(
              "Features",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF030F2D),
              ),
            ),
            _buildFeatureCard(
                context, 'Daily Standup Reminder', Icons.access_time),
            _buildFeatureCard(context, 'Add Team Members', Icons.group_add),
            _buildFeatureCard(
                context, 'View Daily Standup Report', Icons.article),
            _buildFeatureCard(context, 'Share Updates', Icons.share),
          ],
        ),
      ),
    );
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => DailyStandupScreen()), // Define this screen
            // );
          } else if (title == 'View Daily Standup Report') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => DailyStandupReportScreen()), // Define this screen
            // );
          } else if (title == 'Share Updates') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ShareUpdatesScreen()), // Define this screen
            // );
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
