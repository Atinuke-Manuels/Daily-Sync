
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/provider/user_provider.dart';
import '../custom_button.dart';

class DailyStandupReminder extends StatefulWidget {
  const DailyStandupReminder({super.key});

  @override
  State<DailyStandupReminder> createState() => _DailyStandupReminderState();
}

class _DailyStandupReminderState extends State<DailyStandupReminder> {
  TimeOfDay? standupTime;
  List<String> standupDays = [];
  String? adminId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStandupSchedule();
  }

  Future<void> _loadStandupSchedule() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    adminId = userProvider.userId;

    if (adminId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Admin access required")),
        );
        Navigator.pop(context);
      }
      return;
    }

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('standup_settings')
          .doc(adminId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          standupTime = _parseTime(data['standupTime']);
          standupDays = List<String>.from(data['days'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading schedule: $e")),
        );
        setState(() => isLoading = false);
      }
    }
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      List<String> parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return const TimeOfDay(hour: 9, minute: 0); // Fallback to default time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Standup Reminder",
          style: TextStyle(
              fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF030F2D), // Match background color
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStandupInfoCard(),
            const SizedBox(height: 20),
            _buildStandupDaysList(),
            const Spacer(),
            CustomButton(
              title: "Edit Schedule",
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, "/standup_schedule_screen");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandupInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF030F2D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 40, color: Colors.white), // White icon
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Standup Time",
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                standupTime != null ? standupTime!.format(context) : "Not set",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStandupDaysList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Scheduled Days",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // White text
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: standupDays.map((day) {
            return Chip(
              label: Text(day,
                  style: const TextStyle(color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
              ), // White text
              backgroundColor: const Color(0xFF030F2D),
            );
          }).toList(),
        ),
      ],
    );
  }
}