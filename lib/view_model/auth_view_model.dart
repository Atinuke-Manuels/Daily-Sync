import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/models/user_model.dart';
import '../core/services/auth_service.dart';
import '../core/services/user_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  /// Checks if user is already signed in on app startup
  Future<void> checkUserLoginStatus() async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      await fetchUserData(user.uid);
    }
  }

  /// Listens for authentication state changes
  void listenToAuthChanges() {
    _authService.authStateChanges().listen((user) async {
      if (user != null) {
        await fetchUserData(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> fetchUserData(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception("User ID is empty"); // Validate userId
      }

      DocumentSnapshot userSnapshot = await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        _currentUser = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        notifyListeners();
      } else {
        throw Exception("User not found in Firestore");
      }
    } catch (e) {
      print("Error fetching user: $e");
      throw e; // Re-throw the error to handle it in the calling method
    }
  }

  String get userRole => _currentUser?.role ?? "";

  /// Sign Up User
  Future<bool> signUp(String email, String password, String name, String role) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Create user in Firebase Auth and Firestore
      UserModel? user = await _authService.signUp(email, password, name, role); // 🔹 Pass name & role

      if (user != null) {
        // Fetch user data and update state
        await fetchUserData(user.id);
        return true;
      } else {
        _errorMessage = "Signup failed. Please try again.";
        return false;
      }
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Sign In User
  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserModel? userModel = await _authService.signIn(email, password);

      if (userModel != null) {
        print("✅ UserModel found: ${userModel.toString()}");
        print("Fetching user data for userId: ${userModel.id}"); // Debug statement
        await fetchUserData(userModel.id);
        _currentUser = userModel;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Invalid email or password";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Sign Out User
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
