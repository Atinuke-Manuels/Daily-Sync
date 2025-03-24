import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../core/provider/user_provider.dart';

class  MyDailyStandupReportsScreen extends StatelessWidget {

  const  MyDailyStandupReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserProvider>(context).userId;
    // print("User ID: $userId");
    return Scaffold(
      appBar: AppBar(title: Text("My Standup Reports", style: AppTextStyles.displayMedium(context),), centerTitle: true,),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('standups')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // print("Firestore error: ${snapshot.error}");
            return Center(child: Text("Error loading data"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // print("No standup reports found for user: $userId");
            return const Center(child: Text("No Standup Reports Available"));
          }


          var standups = snapshot.data!.docs;

          return ListView.builder(
            itemCount: standups.length,
            itemBuilder: (context, index) {
              var standup = standups[index];
              var data = standup.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Yesterday: ${data['yesterday']}"),
                      SizedBox(height: 10,),
                      Text("Today: ${data['today']}"),
                      SizedBox(height: 10,),
                      Text("Blockers: ${data['blockers']}"),
                      SizedBox(height: 10,),
                    ],
                  ),
                  subtitle: Text("Submitted at: ${data['createdAt'].toDate()}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editReport(context, standup.id, data),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteReport(context, standup.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editReport(BuildContext context, String docId, Map<String, dynamic> data) {
    TextEditingController yesterdayController = TextEditingController(text: data['yesterday']);
    TextEditingController todayController = TextEditingController(text: data['today']);
    TextEditingController blockersController = TextEditingController(text: data['blockers']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Report"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: yesterdayController, decoration: const InputDecoration(labelText: "Yesterday"), minLines: 1,),
            TextField(controller: todayController, decoration: const InputDecoration(labelText: "Today"), minLines: 1,),
            TextField(controller: blockersController, decoration: const InputDecoration(labelText: "Blockers"), minLines: 1,),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('standups').doc(docId).update({
                'yesterday': yesterdayController.text,
                'today': todayController.text,
                'blockers': blockersController.text,
                'updatedAt': Timestamp.now(),
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteReport(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Report"),
        content: const Text("Are you sure you want to delete this report?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('standups').doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
