import 'package:flutter/material.dart';

import '../custom_button.dart';

class ShareUpdates extends StatefulWidget {
  const ShareUpdates({super.key});

  @override
  State<ShareUpdates> createState() => _ShareUpdatesState();
}

class _ShareUpdatesState extends State<ShareUpdates> {
  final TextEditingController _updateController = TextEditingController();
  DateTime? _selectedDateTime;

  void _pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _sendUpdate() {
    if (_updateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an update")),
      );
      return;
    }

    String updateText = _updateController.text;
    String scheduledTime = _selectedDateTime == null
        ? "Now"
        : "${_selectedDateTime!.toLocal()}".split('.')[0];

    String finalUpdate = "$updateText (Scheduled: $scheduledTime)";

    // Pass the update back to the Admin Dashboard
    // widget.onUpdateShared(finalUpdate);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Update shared successfully!")),
    );

    // Clear the input fields and go back
    _updateController.clear();
    setState(() {
      _selectedDateTime = null;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Updates",
          style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        ),
        backgroundColor: const Color(0xFF030F2D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,), // Back button
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _updateController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "Write an update...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Row(
            //   children: [
            //     ElevatedButton.icon(
            //       onPressed: () => _pickDateTime(context),
            //       icon: const Icon(Icons.calendar_today),
            //       label: const Text("Pick Date & Time"),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFF030F2D),
            //       ),
            //     ),
            //     const SizedBox(width: 10),
            //     Expanded(
            //       child: Text(
            //         _selectedDateTime == null
            //             ? "No date selected"
            //             : "Scheduled: ${_selectedDateTime!.toLocal()}".split('.')[0],
            //         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            //       ),
            //     ),
            //   ],
            // ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                title: 'share Updates',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
