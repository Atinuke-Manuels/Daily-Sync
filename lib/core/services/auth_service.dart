import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../models/user_model.dart';
import 'notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign up new user
  Future<UserModel?> signUp(String email, String password, String name, String role, String department) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        department: department,
        role: role,
        profileImage: "",
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore.collection('users').doc(newUser.id).set({
        ...newUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return newUser;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }


  /// get onesignal player ID for push notifications
  Future<void> updateUserWithOneSignalID(String userId) async {
    // Get the OneSignal user ID (player ID)
    final playerId = await OneSignal.User.getOnesignalId();

    // Check if the player ID is not null
    if (playerId != null) {
      // Update the Firestore document with the OneSignal ID
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'oneSignalId': playerId,
      });
    } else {
      print("OneSignal ID is null. Unable to update user.");
    }
  }



  /// Sign in user

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update Firestore with OneSignal Player ID
      await updateUserWithOneSignalID(userCredential.user!.uid);

      return await getUserById(userCredential.user!.uid);
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }


  /// Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Check if user is already signed in
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Listen to authentication state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  /// Fetch user data from Firestore
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  // Check if the user is an admin
  Future<bool> isAdmin() async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) return false;

    String role = userDoc['role'] ?? '';
    return role.toLowerCase() == 'admin';
  }
}
