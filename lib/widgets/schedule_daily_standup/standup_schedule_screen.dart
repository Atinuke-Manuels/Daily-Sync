import 'package:daily_sync/widgets/custom_button.dart';
import 'package:daily_sync/widgets/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/provider/user_provider.dart';

class StandupScheduleScreen extends StatefulWidget {
  const StandupScheduleScreen({super.key});

  @override
  _StandupScheduleScreenState createState() => _StandupScheduleScreenState();
}

class _StandupScheduleScreenState extends State<StandupScheduleScreen> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  List<String> selectedDays = [];
  bool isLoading = true;
  String? adminId;
  List<String>? _originalDays;
  TimeOfDay? _originalTime;

  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  void initState() {
    super.initState();
    _getAdminIdAndLoadSchedule();
  }

  Future<void> _getAdminIdAndLoadSchedule() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    adminId = userProvider.userId;

    if (adminId != null) {
      await _loadExistingSchedule();
    } else {
      if (mounted) {
        ShowMessage().showErrorMsg('Admin access required', context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _loadExistingSchedule() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('standup_settings')
          .doc(adminId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          selectedDays = List<String>.from(data['days'] ?? []);
          selectedTime = _parseTime(data['standupTime']);
          _originalDays = List<String>.from(selectedDays);
          _originalTime = selectedTime;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          _originalDays = [];
          _originalTime = selectedTime;
        });
      }
    } catch (e) {
      if (mounted) {
        ShowMessage().showErrorMsg('Error loading schedule: $e', context);
        setState(() => isLoading = false);
      }
    }
  }

  TimeOfDay _parseTime(String timeString) {
    List<String> parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool get _hasChanges {
    // Compare current selection with original values
    final daysEqual = _originalDays != null &&
        const ListEquality().equals(selectedDays, _originalDays!);
    final timeEqual = _originalTime != null &&
        selectedTime.hour == _originalTime!.hour &&
        selectedTime.minute == _originalTime!.minute;

    return !daysEqual || !timeEqual;
  }

  bool get _isValidSchedule => selectedDays.isNotEmpty;

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && mounted) {
      setState(() => selectedTime = pickedTime);
    }
  }

  Future<void> _saveStandupSchedule() async {
    if (!_hasChanges) {
      if (mounted) {
        ShowMessage().showErrorMsg('No changes to save', context);
      }
      return;
    }

    if (!_isValidSchedule) {
      if (mounted) {
        ShowMessage().showErrorMsg('Please select at least one day', context);
      }
      return;
    }

    String formattedTime = DateFormat('HH:mm').format(
      DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
    );

    try {
      await FirebaseFirestore.instance
          .collection('standup_settings')
          .doc(adminId)
          .set({
        'standupTime': formattedTime,
        'days': selectedDays,
        'reminderBefore': 10,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ShowMessage().showSuccessMsg('Standup schedule updated successfully!', context);
        setState(() {
          _originalDays = List<String>.from(selectedDays);
          _originalTime = selectedTime;
        });
      }
    } catch (e) {
      if (mounted) {
        ShowMessage().showErrorMsg('Failed to save schedule: $e', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Standup Schedule Screen"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text("Select Standup Time"),
              subtitle: Text(selectedTime.format(context)),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: _pickTime,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Select Standup Days",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: daysOfWeek.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: selectedDays.contains(day),
                    onChanged: (bool? value) {
                      if (mounted) {
                        setState(() {
                          if (value == true) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(onTap: _saveStandupSchedule, title: 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}