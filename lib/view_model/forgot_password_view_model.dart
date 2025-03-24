import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/show_alert.dart';

class ForgotPasswordViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if email exists in Firestore
  Future<bool> isRegisteredUser(String email) async {
    try {
      var querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Send password reset email if email is registered
  Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    if (email.isEmpty) {
      ShowMessage().showErrorMsg("Email cannot be empty.", context);
      return;
    }

    bool isRegistered = await isRegisteredUser(email);

    if (!isRegistered) {
      ShowMessage().showErrorMsg("Email is not registered.", context);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ShowMessage().showSuccessMsg("Password reset email sent successfully.", context);
    } catch (e) {
      ShowMessage().showErrorMsg("Error sending password reset email: $e", context);
    }
  }
}
