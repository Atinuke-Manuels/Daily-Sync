import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserStandupReminderScreen extends StatefulWidget {
  const UserStandupReminderScreen({super.key});

  @override
  State<UserStandupReminderScreen> createState() => _UserStandupReminderScreenState();
}

class _UserStandupReminderScreenState extends State<UserStandupReminderScreen> {
  TimeOfDay? standupTime;
  List<String> standupDays = [];
  String? standupNote;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStandupSchedule();
  }

  Future<void> _loadStandupSchedule() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('standup_settings')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          standupTime = _parseTime(data['standupTime']);
          standupDays = List<String>.from(data['days'] ?? []);
          standupNote = data['standupNote'] ?? "No note available";
          isLoading = false;
        });
      } else {
        setState(() {
          standupNote = "No note available";
          isLoading = false;
        });
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
      return const TimeOfDay(hour: 9, minute: 0); // Fallback default time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daily Standup Schedule",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF030F2D),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildStandupInfoCard(),
      ),
    );
  }

  Widget _buildStandupInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Standup Note:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF030F2D),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            standupNote ?? "No note available",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF030F2D),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Standup Time:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF030F2D),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, size: 30, color: Color(0xFF030F2D)),
              const SizedBox(width: 10),
              Text(
                standupTime != null ? standupTime!.format(context) : "Not set",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF030F2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "Scheduled Days:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF030F2D),
            ),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 8,
            children: standupDays.map((day) {
              return Chip(
                label: Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                backgroundColor: const Color(0xFF030F2D),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
