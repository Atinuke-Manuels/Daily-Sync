import 'package:flutter/material.dart';

import '../custom_button.dart';

class AddTeamMember extends StatefulWidget {
  const AddTeamMember({super.key});

  @override
  State<AddTeamMember> createState() => _AddTeamMemberState();
}

class _AddTeamMemberState extends State<AddTeamMember> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDepartment;
  final List<String> _departments = ['Engineering', 'Marketing', 'HR', 'Design', 'Sales'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF030F2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Team Members',
          style: TextStyle(
            fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF030F2D),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            const Text(
              'Name',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF030F2D),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 30),

            // Department Dropdown
            const Text(
              'Department',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF030F2D),
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: _selectedDepartment,
              hint: const Text('--Select Option--'),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                });
              },
              items: _departments.map((department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            // Add Team Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                title: 'Add Team',
                onTap: () {
                  if (_nameController.text.isNotEmpty && _selectedDepartment != null) {
                    // Handle adding team member logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Team member added successfully!')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
