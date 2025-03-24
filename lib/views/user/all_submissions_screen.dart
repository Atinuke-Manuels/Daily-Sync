import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../core/utils/format_time_stamp.dart';
import '../../theme/app_text_styles.dart';

class AllSubmissionsScreen extends StatelessWidget {
  const AllSubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Standup Submissions", style: AppTextStyles.displayMedium(context),), centerTitle: true,),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('standups')
            .orderBy('createdAt', descending: true) // Ensure correct timestamp
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No standup submissions yet.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          var standupDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: standupDocs.length,
            itemBuilder: (context, index) {
              var data = standupDocs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatTimestamp(data['createdAt'])),
                      Text("Yesterday: ${data['yesterday']}"),
                      Text("Today: ${data['today']}"),
                      Text("Blockers: ${data['blockers']}"),
                    ],
                  ),
                  subtitle: Text("Updated by: ${data['userName'] ?? 'Unknown'}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
