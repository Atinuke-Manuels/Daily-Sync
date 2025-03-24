import 'package:flutter/material.dart';
import '../core/models/user_model.dart';
import '../core/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();


  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  // Fetch user data from Firebase and convert to UserModel
  Future<void> fetchUser(String userId) async {
    try {
      UserModel? user = await _userService.getUserById(userId);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  // Update user role and notify UI
  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      await _userService.updateUserRole(userId, newRole);
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(role: newRole);
        notifyListeners();
      }
    } catch (e) {
      print("Error updating role: $e");
    }
  }


  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserData() async {
    // Ensure it runs after the widget tree builds
    await Future.delayed(Duration(milliseconds: 100));

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // ✅ Now called safely

    try {
      _userData = await _userService.fetchUserData();
    } catch (e) {
      _errorMessage = "Failed to load user data";
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners()); // ✅ Ensures UI updates correctly
    }
  }

}
