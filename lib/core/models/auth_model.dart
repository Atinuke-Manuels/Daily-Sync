class AuthModel {
  final String userId;
  final String email;
  final bool isAuthenticated;

  AuthModel({
    required this.userId,
    required this.email,
    this.isAuthenticated = false,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'isAuthenticated': isAuthenticated,
    };
  }

  // Create AuthModel from Firebase Map
  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? false,
    );
  }
}
