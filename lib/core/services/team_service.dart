import 'package:cloud_firestore/cloud_firestore.dart';

class TeamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches unique departments from the users collection
  Future<List<String>> fetchDepartments() async {
    var snapshot = await _firestore.collection('users').get();
    var uniqueDepartments = snapshot.docs
        .map((doc) => doc["department"] as String?)
        .where((dept) => dept != null && dept.isNotEmpty)
        .toSet()
        .toList();

    return ["All", ...uniqueDepartments.cast<String>()];
  }

  /// Fetches a stream of all users from Firestore
  Stream<List<Map<String, dynamic>>> fetchUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return {
          "name": data["name"] ?? "Unknown",
          "department": data["department"] ?? "Unknown"
        };
      }).toList();
    });
  }
}
