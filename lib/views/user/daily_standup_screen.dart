import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:daily_sync/widgets/user_home_widgets/stand_up_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/provider/user_provider.dart';
import '../../widgets/user_home_widgets/date_section_label.dart';
import '../../widgets/user_home_widgets/stand_up_report_text.dart';

class MyDailyStandupReportsScreen extends StatelessWidget {
  const MyDailyStandupReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    String userId = Provider.of<UserProvider>(context).userId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "My Standup Reports",
          style: AppTextStyles.displayMedium(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, right: 24, left: 24),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('standups')
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading data"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No Standup Reports Available"));
            }

            var standups = snapshot.data!.docs;

            /// Group reports into categories
            Map<String, List<DocumentSnapshot>> groupedReports = {};

            for (var doc in standups) {
              var data = doc.data() as Map<String, dynamic>;
              DateTime createdAt = (data['createdAt'] as Timestamp).toDate();
              String sectionLabel = getSectionLabel(createdAt);

              if (!groupedReports.containsKey(sectionLabel)) {
                groupedReports[sectionLabel] = [];
              }
              groupedReports[sectionLabel]!.add(doc);
            }

            return ListView(
              children: groupedReports.entries.map((entry) {
                String sectionTitle = entry.key;
                List<DocumentSnapshot> reports = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          sectionTitle,
                          style: AppTextStyles.displayTiny(context)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ...reports.map((standup) {
                      var data = standup.data() as Map<String, dynamic>;

                      return standUpCard(
                        context,
                        ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StandUpReportText(
                                  title: "Yesterday: ",
                                  subTitle: "${data['yesterday']}"),
                              StandUpReportText(
                                  title: "Today: ",
                                  subTitle: "${data['today']}"),
                              StandUpReportText(
                                  title: "Blockers: ",
                                  subTitle: "${data['blockers']}"),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StandUpReportText(
                                  title: "Submitted at: ",
                                  subTitle: DateFormat('dd-MM-yyyy HH:mm')
                                      .format(data['createdAt'].toDate())),
                              const SizedBox(height: 14),
                              // Check if within 1 hour
                              if (DateTime.now()
                                  .difference(data['createdAt'].toDate())
                                  .inHours <
                                  1)
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 155,
                                      height: 40,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              colors.onError),
                                          side: WidgetStateProperty.all<
                                              BorderSide>(
                                            BorderSide(color: colors.primary),
                                          ),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Edit',
                                          style: AppTextStyles.labelMedium(
                                              context)
                                              .copyWith(
                                              color: colors.primary,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        onPressed: () =>
                                            _editReport(context, standup.id, data),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 155,
                                      height: 40,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.red),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Delete',
                                          style: AppTextStyles.labelMedium(
                                              context)
                                              .copyWith(
                                              color: colors.onError,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        onPressed: () =>
                                            _deleteReport(context, standup.id),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Reports can only be edited/deleted within 1 hour of submission.',
                                    style: AppTextStyles.displayTiny(context)
                                        .copyWith(
                                      color: colors.onSurfaceVariant,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              // Comments Section
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('standups')
                                      .doc(standup.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return const Text("No comments yet.",
                                          style: TextStyle(color: Colors.grey));
                                    }

                                    var standupData =
                                    snapshot.data!.data() as Map<String, dynamic>;

                                    if (standupData["comments"] == null ||
                                        (standupData["comments"] as List)
                                            .isEmpty) {
                                      return const Text("No comments yet.",
                                          style: TextStyle(color: Colors.grey));
                                    }

                                    List comments = standupData["comments"];

                                    return SingleChildScrollView(
                                      child: Column(
                                        children: comments.map((comment) {
                                          var commentData =
                                          comment as Map<String, dynamic>;
                                          return ListTile(
                                            title: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Comments by:', style: AppTextStyles.labelTiny(context).copyWith(fontWeight: FontWeight.bold),),
                                                Text(
                                                    commentData["name"] ?? "Unknown"),
                                              ],
                                            ),
                                            subtitle: Text(
                                                commentData["content"] ?? ""),
                                            trailing: Text(
                                              DateFormat('dd-MM-yyyy HH:mm')
                                                  .format(
                                                (commentData["createdAt"]
                                                as Timestamp)
                                                    .toDate(),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  void _editReport(
      BuildContext context, String docId, Map<String, dynamic> data) {
    TextEditingController yesterdayController =
    TextEditingController(text: data['yesterday']);
    TextEditingController todayController =
    TextEditingController(text: data['today']);
    TextEditingController blockersController =
    TextEditingController(text: data['blockers']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Report"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: yesterdayController,
              decoration: const InputDecoration(labelText: "Yesterday"),
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            TextField(
              controller: todayController,
              decoration: const InputDecoration(labelText: "Today"),
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            TextField(
              controller: blockersController,
              decoration: const InputDecoration(labelText: "Blockers"),
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('standups')
                  .doc(docId)
                  .update({
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
              FirebaseFirestore.instance
                  .collection('standups')
                  .doc(docId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}