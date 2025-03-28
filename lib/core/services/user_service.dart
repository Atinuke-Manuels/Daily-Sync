import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Add User to Firestore with Firebase Auth UID
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
    }
  }



  /// Fetch user data from Firestore
  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final user = _authService.getCurrentUser(); // Get current user

      if (user == null) {
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore.collection('users').doc(user.uid).get();

      return doc.data();
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  // Add User to Firestore
  Future<void> addUser({required String name, required String email, required String role}) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc();
      await userRef.set({
        'uid': userRef.id,
        'name': name,
        'email': email,
        'role': role,
        'profileImage': "", // Default profile image
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  // Get User by ID and convert to UserModel
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  // Update User Role
  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
    } catch (e) {
      print("Error updating user role: $e");
    }
  }
}
