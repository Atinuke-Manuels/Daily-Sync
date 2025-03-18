import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StandupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> canSubmitStandup(String userId) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('standups')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      Timestamp lastSubmission = query.docs.first['createdAt'];
      DateTime lastDate = lastSubmission.toDate();
      DateTime today = DateTime.now();

      return lastDate.year != today.year ||
          lastDate.month != today.month ||
          lastDate.day != today.day; // Ensure the last submission is not today
    }
    return true;
  }

  Future<void> submitStandup(String userId, Map<String, String> updates) async {
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      String userName = 'Unknown User';

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userName = userData.containsKey('name') ? userData['name'] : 'Unknown User';
      }

      if (await canSubmitStandup(userId)) {
        await FirebaseFirestore.instance.collection('standups').add({
          "userId": userId,
          "userName": userName,
          "yesterday": updates["yesterday"] ?? '',
          "today": updates["today"] ?? '',
          "blockers": updates["blockers"] ?? '',
          "createdAt": Timestamp.now(),
        });
      } else {
        throw Exception("You can only submit one standup update per day.");
      }
    } catch (e, stackTrace) {
      debugPrint("Error in submitStandup: $e");
      debugPrint("StackTrace: $stackTrace");
      throw Exception("Failed to submit standup. Please try again.");
    }
  }


  bool canEditOrDelete(Timestamp createdAt) {
    final now = DateTime.now();
    final createdTime = createdAt.toDate();
    final difference = now.difference(createdTime);
    return difference.inHours < 1;
  }

  Future<List<Map<String, dynamic>>> fetchTeamUpdates(String teamId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('standups')
          .where('teamId', isEqualTo: teamId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching updates: $e');
      return [];
    }
  }


  Future<void> setReminderTime(String teamId, String time) async {
    try {
      await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
        'reminderTime': time,
      });
    } catch (e) {
      print('Error setting reminder: $e');
    }
  }


  Future<void> deleteStandupUpdate(String updateId, String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('standups').doc(updateId).get();

      if (doc.exists && doc['userId'] == userId) {
        await FirebaseFirestore.instance.collection('standups').doc(updateId).delete();
      } else {
        print("Unauthorized or non-existing update.");
      }
    } catch (e) {
      print('Error deleting update: $e');
    }
  }

}
