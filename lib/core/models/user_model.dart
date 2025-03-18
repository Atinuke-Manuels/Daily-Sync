import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // Now correctly mapped from 'uid'
  final String name;
  final String email;
  final String role;
  final String profileImage;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profileImage,
    required this.createdAt,
  });

  // Convert Firestore Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
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
    String? role,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
