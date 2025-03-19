import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // Now correctly mapped from 'uid'
  final String name;
  final String email;
  final String department;
  final String role;
  final String profileImage;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
    required this.profileImage,
    required this.createdAt,
  });

  // Convert Firestore Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['uid'] ?? '',
      name: data['name'] ?? 'Guest',
      email: data['email'] ?? '',
      department: data['department'] ?? 'Select department',
      role: data['role'] ?? '',
      profileImage: data['profileImage'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert UserModel to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': id, // ✅ Now storing it as 'uid' instead of 'id'
      'name': name,
      'email': email,
      'department' : department,
      'role': role,
      'profileImage': profileImage,
      'createdAt': createdAt,
    };
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? department,
    String? role,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
