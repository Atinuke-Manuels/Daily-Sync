// import 'package:daily_sync/widgets/custom_button.dart';
// import 'package:daily_sync/widgets/show_alert.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../core/provider/user_provider.dart';
//
// class StandupScheduleScreen extends StatefulWidget {
//   const StandupScheduleScreen({super.key});
//
//   @override
//   _StandupScheduleScreenState createState() => _StandupScheduleScreenState();
// }
//
// class _StandupScheduleScreenState extends State<StandupScheduleScreen> {
//   TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
//   List<String> selectedDays = [];
//   bool isLoading = true;
//   String? adminId;
//   List<String>? _originalDays;
//   TimeOfDay? _originalTime;
//
//   final List<String> daysOfWeek = [
//     "Monday",
//     "Tuesday",
//     "Wednesday",
//     "Thursday",
//     "Friday",
//     "Saturday",
//     "Sunday"
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _getAdminIdAndLoadSchedule();
//   }
//
//   Future<void> _getAdminIdAndLoadSchedule() async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     adminId = userProvider.userId;
//
//     if (adminId != null) {
//       await _loadExistingSchedule();
//     } else {
//       if (mounted) {
//         ShowMessage().showErrorMsg('Admin access required', context);
//         Navigator.pop(context);
//       }
//     }
//   }
//
//   Future<void> _loadExistingSchedule() async {
//     try {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection('standup_settings')
//           .doc(adminId)
//           .get();
//
//       if (doc.exists) {
//         var data = doc.data() as Map<String, dynamic>;
//         setState(() {
//           selectedDays = List<String>.from(data['days'] ?? []);
//           selectedTime = _parseTime(data['standupTime']);
//           _originalDays = List<String>.from(selectedDays);
//           _originalTime = selectedTime;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           _originalDays = [];
//           _originalTime = selectedTime;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ShowMessage().showErrorMsg('Error loading schedule: $e', context);
//         setState(() => isLoading = false);
//       }
//     }
//   }
//
//   TimeOfDay _parseTime(String timeString) {
//     List<String> parts = timeString.split(':');
//     return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
//   }
//
//   bool get _hasChanges {
//     // Compare current selection with original values
//     final daysEqual = _originalDays != null &&
//         const ListEquality().equals(selectedDays, _originalDays!);
//     final timeEqual = _originalTime != null &&
//         selectedTime.hour == _originalTime!.hour &&
//         selectedTime.minute == _originalTime!.minute;
//
//     return !daysEqual || !timeEqual;
//   }
//
//   bool get _isValidSchedule => selectedDays.isNotEmpty;
//
//   void _pickTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//
//     if (pickedTime != null && mounted) {
//       setState(() => selectedTime = pickedTime);
//     }
//   }
//
//   Future<void> _saveStandupSchedule() async {
//     if (!_hasChanges) {
//       if (mounted) {
//         ShowMessage().showErrorMsg('No changes to save', context);
//       }
//       return;
//     }
//
//     if (!_isValidSchedule) {
//       if (mounted) {
//         ShowMessage().showErrorMsg('Please select at least one day', context);
//       }
//       return;
//     }
//
//     String formattedTime = DateFormat('HH:mm').format(
//       DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
//     );
//
//     try {
//       await FirebaseFirestore.instance
//           .collection('standup_settings')
//           .doc(adminId)
//           .set({
//         'standupTime': formattedTime,
//         'days': selectedDays,
//         'reminderBefore': 10,
//         'lastUpdated': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//
//       if (mounted) {
//         ShowMessage().showSuccessMsg('Standup schedule updated successfully!', context);
//         setState(() {
//           _originalDays = List<String>.from(selectedDays);
//           _originalTime = selectedTime;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ShowMessage().showErrorMsg('Failed to save schedule: $e', context);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Standup Schedule Screen",
//           style: TextStyle(
//           fontWeight: FontWeight.bold,
//             fontSize: 18,
//               color: Color(0xFF030F2D)
//         ),),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ListTile(
//               title: const Text("Select Standup Time"),
//               subtitle: Text(selectedTime.format(context)),
//               trailing: IconButton(
//                 icon: const Icon(Icons.access_time),
//                 onPressed: _pickTime,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Select Standup Days",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: ListView(
//                 children: daysOfWeek.map((day) {
//                   return CheckboxListTile(
//                     title: Text(day),
//                     value: selectedDays.contains(day),
//                     onChanged: (bool? value) {
//                       if (mounted) {
//                         setState(() {
//                           if (value == true) {
//                             selectedDays.add(day);
//                           } else {
//                             selectedDays.remove(day);
//                           }
//                         });
//                       }
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: CustomButton(onTap: _saveStandupSchedule, title: 'Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../core/provider/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/show_alert.dart';
import '../custom_text_field.dart'; // Import CustomTextField

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
  final TextEditingController _noteController = TextEditingController(); // Controller for note

  final List<String> daysOfWeek = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
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
          _noteController.text = data['standupNote'] ?? ""; // Load saved note
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
    try {
      List<String> parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      ShowMessage().showErrorMsg('Invalid time format: $e', context);
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

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
        'standupNote': _noteController.text,
        'reminderBefore': 10,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ShowMessage().showSuccessMsg('Standup schedule updated successfully!', context);
      setState(() {
        _originalDays = List<String>.from(selectedDays);
        _originalTime = selectedTime;
      });
    } catch (e) {
      ShowMessage().showErrorMsg('Failed to save schedule: $e', context);
    }
  }

  Future<void> _cancelSchedule() async {
    try {
      await FirebaseFirestore.instance.collection('standup_settings').doc(adminId).delete();

      ShowMessage().showSuccessMsg('Schedule canceled successfully!', context);
      setState(() {
        selectedDays.clear();
        selectedTime = const TimeOfDay(hour: 9, minute: 0);
        _noteController.clear();
      });
    } catch (e) {
      ShowMessage().showErrorMsg('Failed to cancel schedule: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Standup Schedule", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          reverse: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text("Standup Note",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _noteController,
                label: "Enter a short standup note",
                hint: "E.g. Daily team sync-up meeting",
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: const Text(
                    "Select Standup Time",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(selectedTime.format(context)),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _pickTime,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text("Select Standup Days",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0, // Space between chips
                runSpacing: 8.0, // Space between rows if wrapped
                children: daysOfWeek.map((day) {
                  bool isSelected = selectedDays.contains(day);
                  return ChoiceChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0xFF030F2D),
                    checkmarkColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF030F2D), width: 1.5),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF030F2D),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              CustomButton(onTap: _saveStandupSchedule, title: 'Save Schedule'),
              // const SizedBox(height: 16),
              CustomButton(onTap: _cancelSchedule, title: 'Cancel Schedule', btnColor: Theme.of(context).colorScheme.error,),
            ],
          ),
        ),
      ),
    );
  }
}
