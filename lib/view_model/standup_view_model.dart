import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/services/standup_service.dart';

class StandupViewModel extends ChangeNotifier {
  final StandupService _standupService = StandupService();

  List<Map<String, dynamic>> _teamUpdates = [];

  List<Map<String, dynamic>> get teamUpdates => _teamUpdates;

  Future<void> loadTeamUpdates(String teamId) async {
    _teamUpdates = await _standupService.fetchTeamUpdates(teamId);
    notifyListeners(); // Triggers UI update
  }


  Stream<QuerySnapshot> getStandupReports() {
    return _standupService.getStandupReports();
  }

  Future<void> deleteReport(BuildContext context, String docId, Timestamp createdAt) async {
    try {
      await _standupService.deleteReport(docId, createdAt);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report deleted successfully."), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> addOrUpdateComment(BuildContext context, String docId, String commentText) async {
    if (commentText.trim().isEmpty) return;

    try {
      await _standupService.addOrUpdateComment(docId, commentText);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment added/updated successfully."), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}

