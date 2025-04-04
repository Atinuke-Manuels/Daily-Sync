import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamMembersViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> departments = ["All"];

  Future<void> fetchDepartments() async {
    var snapshot = await _firestore.collection('users').get();
    var uniqueDepartments = snapshot.docs
        .map((doc) => doc["department"] as String?)
        .where((dept) => dept != null && dept.isNotEmpty)
        .toSet()
        .toList();

    departments = ["All", ...uniqueDepartments.cast<String>()];
    notifyListeners();
  }

  Stream<List<Map<String, dynamic>>> fetchUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return {
          "id": doc.id,
          "name": data["name"],
          "email": data["email"],
          "role": data["role"],
          "department": data["department"],
          "isDisabled": data["isDisabled"] ?? false, // Default to false
        };
      }).toList();
    });
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('users').doc(userId).update(updatedData);
  }
}
