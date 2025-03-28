import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../view_model/standup_view_model.dart';

class DailyStandup extends StatelessWidget {
  const DailyStandup({super.key});

  @override
  Widget build(BuildContext context) {
    final standupViewModel = Provider.of<StandupViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Standup Reports', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: standupViewModel.getStandupReports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No standup submissions yet."));
            }

            var standupDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: standupDocs.length,
              itemBuilder: (context, index) {
                var doc = standupDocs[index];
                var data = doc.data() as Map<String, dynamic>;
                String docId = doc.id;
                DateTime createdAt = (data['createdAt'] as Timestamp).toDate();

                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRichText('Name:', data['userName'] ?? 'Unknown'),
                        _buildRichText('Today’s Task:', data['today']),
                        _buildRichText('Yesterday Task:', data['yesterday']),
                        _buildRichText('Blockers:', data['blockers']),
                        _buildRichText('Date:', formatDate(createdAt)),
                        _buildRichText('Time:', formatTime(createdAt)),

                        // Display Comments Below the Standup Report
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('standups').doc(docId).snapshots(),
                          builder: (context, commentSnapshot) {
                            if (commentSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!commentSnapshot.hasData || commentSnapshot.data == null || !(commentSnapshot.data!.data() as Map<String, dynamic>).containsKey('comments')) {
                              return const Text("No comments yet.", style: TextStyle(fontStyle: FontStyle.italic));
                            }

                            var commentData = commentSnapshot.data!.data() as Map<String, dynamic>;
                            List<dynamic> comments = commentData['comments'] ?? [];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const Text("Comments:", style: TextStyle(fontWeight: FontWeight.bold)),
                                ...comments.map((comment) {
                                  return ListTile(
                                    leading: const Icon(Icons.comment, color: Colors.grey),
                                    title: Text(comment['content'] ?? ''),
                                    subtitle: Text("By ${comment['name'] ?? 'Unknown'} @ ${formatDate((comment['createdAt'] as Timestamp).toDate())} ${formatTime((comment['createdAt'] as Timestamp).toDate())}"),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.comment, color: Colors.green),
                              onPressed: () {
                                TextEditingController commentController = TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Add Comment"),
                                    content: TextField(controller: commentController),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          standupViewModel.addOrUpdateComment(context, docId, commentController.text);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Save"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => standupViewModel.deleteReport(context, docId, data['createdAt']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF030F2D),
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF030F2D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
}
