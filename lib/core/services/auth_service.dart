import 'package:daily_sync/widgets/show_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../models/user_model.dart';
import 'firebase_auth_exception.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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
    } on FirebaseAuthException catch (e) {
      throw Exception(getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw Exception("An unexpected error occurred. Please try again.");
    }
  }



  /// Sign in user

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // // Update Firestore with OneSignal Player ID
      // await updateUserWithOneSignalID(userCredential.user!.uid);

      return await getUserById(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw Exception("An unexpected error occurred. Please try again.");
    }
  }

  /// Forgot password
  Future<void> forgotPasswordReset(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ShowMessage().showSuccessMsg("Password reset email sent successfully.", context);
    } catch (e) {
      ShowMessage().showErrorMsg("Error sending password reset email: $e", context);
      // throw e; // Rethrow the error if you want to handle it elsewhere
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


  /// Fetches the entire user document from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = getCurrentUser();
      if (user == null) return null; // No user logged in

      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null; // User document doesn't exist
      }
    } catch (e) {
      // print("Error fetching user data: $e");
      return null;
    }
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
