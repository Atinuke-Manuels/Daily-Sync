import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return "Unknown time";

  DateTime dateTime = timestamp.toDate();
  return DateFormat('EEEE, d MMMM y • h:mm a').format(dateTime);
}
