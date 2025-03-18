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
}
