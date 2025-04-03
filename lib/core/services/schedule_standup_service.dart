// standup_schedule_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/provider/user_provider.dart';
import '../../widgets/show_alert.dart';

class StandupScheduleService {
  final BuildContext context;
  final String? adminId;
  StandupScheduleService({required this.context, this.adminId});

  Future<void> loadExistingSchedule(Function(List<String> selectedDays, TimeOfDay selectedTime, bool isLoading) callback) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('standup_settings')
          .doc(adminId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        List<String> selectedDays = List<String>.from(data['days'] ?? []);
        TimeOfDay selectedTime = _parseTime(data['standupTime']);
        callback(selectedDays, selectedTime, false);
      } else {
        callback([], const TimeOfDay(hour: 9, minute: 0), false);
      }
    } catch (e) {
      ShowMessage().showErrorMsg('Error loading schedule: $e', context);
      callback([], const TimeOfDay(hour: 9, minute: 0), false);
    }
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      List<String> parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      ShowMessage().showErrorMsg('Invalid time format: $e', context);
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  Future<void> saveStandupSchedule(List<String> selectedDays, TimeOfDay selectedTime) async {
    if (selectedDays.isEmpty) {
      ShowMessage().showErrorMsg('Please select at least one day', context);
      return;
    }

    String formattedTime = DateFormat('HH:mm').format(
      DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
    );

    try {
      await FirebaseFirestore.instance.collection('standup_settings').doc(adminId).set({
        'standupTime': formattedTime,
        'days': selectedDays,
        'reminderBefore': 10,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ShowMessage().showSuccessMsg('Standup schedule updated successfully!', context);
    } catch (e) {
      ShowMessage().showErrorMsg('Failed to save schedule: $e', context);
    }
  }

  Future<void> cancelSchedule() async {
    try {
      await FirebaseFirestore.instance.collection('standup_settings').doc(adminId).delete();

      ShowMessage().showSuccessMsg('Schedule canceled successfully!', context);
    } catch (e) {
      ShowMessage().showErrorMsg('Failed to cancel schedule: $e', context);
    }
  }
}
