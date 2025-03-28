// import 'package:flutter/material.dart';
//
// class StandupReminder extends StatefulWidget {
//   const StandupReminder({super.key});
//
//   @override
//   State<StandupReminder> createState() => _StandupReminderState();
// }
//
// class _StandupReminderState extends State<StandupReminder> {
//   List<Map<String, String>> reminders = [];
//
//   void _showReminderPopup(BuildContext context) {
//     TextEditingController reminderController = TextEditingController();
//     TimeOfDay selectedTime = TimeOfDay.now();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 16,
//             right: 16,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Set Daily Stand-Up Reminder",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: reminderController,
//                 decoration: InputDecoration(
//                   hintText: "Enter reminder details...",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () async {
//                       TimeOfDay? picked = await showTimePicker(
//                         context: context,
//                         initialTime: selectedTime,
//                       );
//                       if (picked != null) {
//                         setState(() {
//                           selectedTime = picked;
//                         });
//                       }
//                     },
//                     icon: const Icon(Icons.access_time),
//                     label: const Text("Pick Time"),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     "Selected: ${selectedTime.format(context)}",
//                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     padding: const EdgeInsets.all(15),
//                   ),
//                   onPressed: () {
//                     if (reminderController.text.isNotEmpty) {
//                       setState(() {
//                         reminders.add({
//                           "text": reminderController.text,
//                           "time": selectedTime.format(context),
//                         });
//                       });
//                       Navigator.pop(context);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Reminder cannot be empty!")),
//                       );
//                     }
//                   },
//                   child: const Text("Save Reminder", style: TextStyle(fontSize: 16)),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () => _showReminderPopup(context),
//           icon: const Icon(Icons.notifications_active),
//           label: const Text("Create Stand-Up Reminder"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blueAccent,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//           ),
//         ),
//         const SizedBox(height: 20),
//         const Text(
//           "Scheduled Reminders:",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         reminders.isEmpty
//             ? const Center(child: Text("No reminders set yet!"))
//             : ListView.builder(
//           shrinkWrap: true,
//           itemCount: reminders.length,
//           itemBuilder: (context, index) {
//             return Card(
//               elevation: 3,
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               child: ListTile(
//                 title: Text(reminders[index]["text"]!),
//                 subtitle: Text("Scheduled at: ${reminders[index]["time"]!}"),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     setState(() {
//                       reminders.removeAt(index);
//                     });
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
