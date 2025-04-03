import 'package:flutter/material.dart';

import '../../view_model/team_view_model.dart';

void showUserDialog(BuildContext context, {Map<String, dynamic>? userData, required TeamMembersViewModel viewModel}) {
  final TextEditingController nameController = TextEditingController(text: userData?['name']);
  final TextEditingController emailController = TextEditingController(text: userData?['email']);
  final TextEditingController roleController = TextEditingController(text: userData?['role']);
  final TextEditingController departmentController = TextEditingController(text: userData?['department']);
  bool isDisabled = userData?['isDisabled'] ?? false;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(userData == null ? 'Add User' : 'Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: roleController, decoration: const InputDecoration(labelText: 'Role')),
            TextField(controller: departmentController, decoration: const InputDecoration(labelText: 'Department')),

            // Toggle switch for enabling/disabling user
            SwitchListTile(
              title: const Text('Disable User'),
              value: isDisabled,
              onChanged: (value) {
                isDisabled = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (userData != null) {
                viewModel.updateUser(userData['id'], {
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'role': roleController.text.trim(),
                  'department': departmentController.text.trim(),
                  'isDisabled': isDisabled,
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
