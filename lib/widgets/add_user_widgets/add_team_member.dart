import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_sync/view_model/auth_view_model.dart';
import 'package:daily_sync/widgets/show_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../custom_button.dart';
import '../custom_text_field.dart';
import '../custom_dropdown.dart';

class AddTeamMember extends StatefulWidget {
  const AddTeamMember({super.key});

  @override
  State<AddTeamMember> createState() => _AddTeamMemberState();
}

class _AddTeamMemberState extends State<AddTeamMember> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedRole;

  final List<String> _departments = [
    'Engineering', 'Marketing', 'HR', 'Design', 'Sales', 'Mobile Dev',
  ];

  final List<String> _roles = ['User', 'Admin'];
  final AuthViewModel authViewModel = AuthViewModel();

  @override
  Widget build(BuildContext context, {QueryDocumentSnapshot? user}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF030F2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
           user == null ? 'Add Team Members' : 'Edit User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF030F2D),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              CustomTextField(
                controller: _nameController,
                label: 'Name',
                hint: 'Enter Name',
              ),
              const SizedBox(height: 20),

              // Email Field
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter Email',
                // keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Department Dropdown
              CustomDropdown(
                label: 'Department',
                items: _departments,
                selectedValue: _selectedDepartment,
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Role Dropdown
              CustomDropdown(
                label: 'Role',
                items: _roles,
                selectedValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 40),

              // Add Team Button
              SizedBox(
                width: double.infinity,
                child: authViewModel.isLoading
                    ? Center(child: const Text('Loading...')) :CustomButton(
                  title: 'Add Member',
                  onTap: () {
                    createUser(
                      context,
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _selectedDepartment!,
                      _selectedRole!,
                      user,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Create or update a user
void createUser(BuildContext context, String name, String email, String department, String role, QueryDocumentSnapshot? user) async {
  if (email.isEmpty || name.isEmpty || role.isEmpty || department.isEmpty) {
    ShowMessage().showErrorMsg('Please fill all fields', context);
    return;
  }

  if (user == null) {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: "Temporary@123", // Temporary password
      );

      // Add user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'createdAt': FieldValue.serverTimestamp(),
        'department' : department,
        'email': email,
        'name': name,
        'profileImage': "",
        'role': role,
        'uid': userCredential.user!.uid,
      });

      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ShowMessage().showSuccessMsg('Team member created successfully! A password reset email has been sent to $email', context);
    } catch (e) {
      ShowMessage().showErrorMsg('Error: ${e.toString()}', context);
    }
  } else {
    // Update existing user in Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
      'email': email,
      'name': name,
      'role': role,
      'department' : department
    });

    ShowMessage().showSuccessMsg('User details updated successfully', context);
  }

  Navigator.pop(context);
}