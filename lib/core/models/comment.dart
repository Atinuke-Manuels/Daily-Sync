import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String username;
  final String userId;
  final String content;
  final Timestamp createdAt;

  Comment({
    required this.id,
    required this.username,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      id: data['id'],
      username: data['username'],
      userId: data['userId'],
      content: data['content'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': username,
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
