// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../core/services/auth_service.dart';
//
// class UserRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final AuthService _authService = AuthService();
//
//   /// Fetch user data from Firestore
//   Future<Map<String, dynamic>?> fetchUserData() async {
//     try {
//       final user = _authService.getCurrentUser(); // Get current user
//
//       if (user == null) {
//         return null;
//       }
//
//       DocumentSnapshot<Map<String, dynamic>> doc =
//       await _firestore.collection('users').doc(user.uid).get();
//
//       return doc.data();
//     } catch (e) {
//       print("Error fetching user data: $e");
//       return null;
//     }
//   }
// }
