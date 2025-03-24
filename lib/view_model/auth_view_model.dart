import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/models/user_model.dart';
import '../core/services/auth_service.dart';
import '../core/services/user_service.dart';
import '../widgets/show_alert.dart';

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
      throw e;
    }
  }

  String get userRole => _currentUser?.role ?? "";

  /// Sign Up User
  Future<UserModel?> signUp(String email, String password, String name, String role, String department) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Create user in Firebase Auth and Firestore
      UserModel? user = await _authService.signUp(email, password, name, role, department);

      if (user != null) {
        await fetchUserData(user.id);
        return user;
      } else {
        throw Exception("Signup failed. Please try again.");
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Sign In User
  Future<UserModel?> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserModel? userModel = await _authService.signIn(email, password);

      if (userModel != null) {
        // print("✅ UserModel found: ${userModel.toString()}");
        // print("Fetching user data for userId: ${userModel.id}"); // Debug statement
        await fetchUserData(userModel.id);
        _currentUser = userModel;
        notifyListeners();
        return userModel;
      } else {
        _errorMessage = "Invalid email or password";
        notifyListeners();
        return null;
      }
    }  catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// forgot password
  Future<void> forgotPassword(String email, BuildContext context) async {
    try {
      await _authService.forgotPasswordReset(email, context);
    } catch (e) {
      ShowMessage().showErrorMsg("Something went wrong: $e", context);
    }
  }


  /// Sign Out User
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
