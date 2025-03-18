import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

class StandupUpdate {
  final String id;
  final String userId;
  final String content;
  final Timestamp createdAt;
  final List<Comment> comments;

  StandupUpdate({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.comments,
  });

  factory StandupUpdate.fromMap(Map<String, dynamic> data, String documentId) {
    return StandupUpdate(
      id: documentId,
      userId: data['userId'],
      content: data['content'],
      createdAt: data['createdAt'],
      comments: (data['comments'] as List<dynamic>?)
          ?.map((c) => Comment.fromMap(c))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }
}
