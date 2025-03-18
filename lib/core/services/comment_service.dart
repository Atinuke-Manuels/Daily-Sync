import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';

class CommentService {
  final CollectionReference standupCollection =
  FirebaseFirestore.instance.collection('standup_updates');

  // Add a comment
  Future<void> addComment(String updateId, Comment comment) async {
    await standupCollection.doc(updateId).update({
      'comments': FieldValue.arrayUnion([comment.toMap()]),
    });
  }

  // Delete a comment
  Future<void> deleteComment(String updateId, Comment comment) async {
    await standupCollection.doc(updateId).update({
      'comments': FieldValue.arrayRemove([comment.toMap()]),
    });
  }
}
