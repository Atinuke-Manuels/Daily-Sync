import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _userId;

  String get userId => _userId ?? "";

  UserProvider() {
    _loadUserId(); // Load saved userId when the app starts
  }

  void setUserId(String id) async {
    _userId = id;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id); // Save userId
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    notifyListeners();
  }
}
