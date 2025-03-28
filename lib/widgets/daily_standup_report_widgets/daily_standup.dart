import 'package:daily_sync/core/services/auth_service.dart';
import 'package:daily_sync/widgets/show_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../core/models/comment.dart';
import '../../core/services/comment_service.dart';
import '../../core/utils/format_time_stamp.dart';
import '../custom_button.dart';

class DailyStandup extends StatefulWidget {
  const DailyStandup({super.key});

  @override
  State<DailyStandup> createState() => _DailyStandupState();
}

class _DailyStandupState extends State<DailyStandup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF030F2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Standup Reports',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF030F2D),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('standups')
              .orderBy('createdAt', descending: true)
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
                var doc = standupDocs[index];
                var data = doc.data() as Map<String, dynamic>;
                String docId = standupDocs[index].id;
                DateTime createdAt = (data['createdAt'] as Timestamp).toDate();
                String formattedDate = formatDate(createdAt); // Custom function for date
                String formattedTime = formatTime(createdAt); // Custom function for time
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRichText('Name:', data['userName'] ?? 'Unknown'),
                        _buildRichText('Today’s Task:', data['today']),
                        _buildRichText('Yesterday Task:', data['yesterday']),
                        _buildRichText('Date:', formattedDate),
                        _buildRichText('Time:', formattedTime),
                        _buildRichText('Any Blockers:', data['blockers']),

                        const SizedBox(height: 12),

                        // Display Comments
                        if (data['comments'] != null && (data['comments'] as List).isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Comments:", style: TextStyle(fontWeight: FontWeight.bold)),
                              ...List.generate(
                                (data['comments'] as List).length,
                                    (index) {
                                  var commentData = data['comments'][index];
                                  return ListTile(
                                    title: Text(commentData['content']),
                                    subtitle: Text("By ${commentData['name'] ?? 'Admin'} @ ${formatTimestamp(commentData['createdAt'])}", ),
                                  );
                                },
                              ),
                            ],
                          ),
Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.comment, color: Colors.green),
                              onPressed: () => _commentOnSubmission(context, doc.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteReport(context, doc.id, data['createdAt']),
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

  void _deleteReport(BuildContext context, String docId, Timestamp createdAt) {
    DateTime reportDate = createdAt.toDate();
    DateTime currentDate = DateTime.now();

    // Check if the report was created today
    bool isSameDay = reportDate.year == currentDate.year &&
        reportDate.month == currentDate.month &&
        reportDate.day == currentDate.day;

    if (isSameDay) {
      // Show confirmation dialog if it's the same day
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this report?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('standups').doc(docId).delete();
                Navigator.pop(context);
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      // Show error message if report is not from today
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reports only be deleted same day they were submitted."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editSubmission(BuildContext context, String docId, Map<String, dynamic> data) {
    TextEditingController yesterdayController = TextEditingController(text: data['yesterday']);
    TextEditingController todayController = TextEditingController(text: data['today']);
    TextEditingController blockersController = TextEditingController(text: data['blockers']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Standup Report"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(yesterdayController, "Yesterday's Task"),
              _buildTextField(todayController, "Today's Task"),
              _buildTextField(blockersController, "Blockers"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('standups').doc(docId).update({
                  'yesterday': yesterdayController.text,
                  'today': todayController.text,
                  'blockers': blockersController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController commentController = TextEditingController();

  void _commentOnSubmission(BuildContext context, String docId) async {
    String adminId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (adminId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not authenticated.")),
      );
      return;
    }

    try {
      // Fetch the document
      DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('standups').doc(docId).get();

      List<dynamic> comments = docSnapshot.exists ? (docSnapshot['comments'] ?? []) : [];

      // Ensure comments list contains only maps
      List<Map<String, dynamic>> parsedComments = comments.cast<Map<String, dynamic>>();

      // Check if current admin has already commented
      Map<String, dynamic>? existingComment;
      try {
        existingComment = parsedComments.firstWhere((comment) => comment['userId'] == adminId);
      } catch (e) {
        existingComment = null;
      }

      // Initialize the text field with existing comment content
      TextEditingController commentController = TextEditingController(
        text: existingComment != null ? existingComment['content'] : '',
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(existingComment != null ? "Edit Comment" : "Add Comment"),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: "Enter your comment..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String commentText = commentController.text.trim();
                if (commentText.isNotEmpty) {
                  try {
                    DocumentSnapshot userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(adminId)
                        .get();
                    String adminName = userDoc.exists ? userDoc['name'] : 'Unknown Admin';

                    if (existingComment != null) {
                      // **Update the existing comment**
                      existingComment['content'] = commentText;
                      existingComment['createdAt'] = Timestamp.now();

                      // Update Firestore document
                      await FirebaseFirestore.instance.collection('standups').doc(docId).update({
                        'comments': parsedComments, // Save updated comments list
                      });

                      ShowMessage().showSuccessMsg("Comment updated successfully!", context);
                    } else {
                      // **Add a new comment**
                      Map<String, dynamic> newComment = {
                        'id': FirebaseFirestore.instance.collection('standups').doc().id,
                        'userId': adminId,
                        'username': adminName,
                        'content': commentText,
                        'createdAt': Timestamp.now(),
                      };

                      // Append the new comment to the list
                      parsedComments.add(newComment);

                      await FirebaseFirestore.instance.collection('standups').doc(docId).update({
                        'comments': parsedComments,
                      });

                      ShowMessage().showSuccessMsg("Comment added successfully!", context);
                    }

                    // Clear text field and close dialog
                    commentController.clear();
                    Navigator.pop(context);
                  } catch (e) {
                    ShowMessage().showErrorMsg("Error: $e", context);
                  }
                }
              },
              child: Text(existingComment != null ? "Update" : "Add"),
            ),
          ],
        ),
      );
    } catch (e) {
      ShowMessage().showErrorMsg("Error fetching comments: $e", context);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
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
