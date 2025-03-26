import 'package:daily_sync/widgets/user_home_widgets/stand_up_card.dart';
import 'package:daily_sync/widgets/user_home_widgets/stand_up_report_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../core/utils/format_time_stamp.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/user_home_widgets/date_section_label.dart';

class AllSubmissionsScreen extends StatelessWidget {
  const AllSubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("All Standup Submissions", style: AppTextStyles.displayMedium(context),), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, right: 24, left: 24),
        child: StreamBuilder<QuerySnapshot>(
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

            /// Group reports into categories
            Map<String, List<DocumentSnapshot>> groupedReports = {};

            for (var doc in standupDocs) {
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        var data = reports[index].data() as Map<String, dynamic>;

                        return standUpCard(
                          context,
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StandUpReportText(title: formatTimestamp(data['createdAt']), subTitle: ''),
                                StandUpReportText(title: 'Yesterday: ', subTitle: '${data['yesterday']}',),
                                StandUpReportText(title: 'Today: ', subTitle: '${data['today']}',),
                                StandUpReportText(title: 'Blockers: ', subTitle: '${data['blockers']}',),
                              ],
                            ),
                            subtitle: StandUpReportText(
                              title: 'Updated by: ',
                              subTitle: '${data['userName'] ?? 'Unknown'}',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            );

          },
        ),
      ),
    );
  }
}
