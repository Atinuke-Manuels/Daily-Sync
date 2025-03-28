// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
//
// Future<void> sendStandupNotification() async {
//   var url = Uri.parse("https://onesignal.com/api/v1/notifications");
//   String apiKey = dotenv.env['API_KEY']!;
//   String basicAuth = 'Basic ${base64Encode(utf8.encode('$apiKey:'))}';
//
//   var body = jsonEncode({
//     "app_id": "35740831-a9ba-43bd-b997-98484d9e9ca1",
//     "included_segments": ["All"],
//     "contents": { "en": "Standup meeting is scheduled!" }
//   });
//
//   var headers = {
//     "Content-Type": "application/json",
//     "Authorization": basicAuth,
//   };
//
//   var response = await http.post(url, headers: headers, body: body);
//
//   if (response.statusCode == 200) {
//     print("Notification sent successfully!");
//   } else {
//     print("Error sending notification: ${response.body}");
//   }
// }


/// for the schedule notification page
// void _saveStandupSchedule() async {
//   String formattedTime = DateFormat('HH:mm').format(
//     DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
//   );
//
//   await FirebaseFirestore.instance
//       .collection('standup_settings')
//       .doc(widget.adminId)
//       .set({
//     'standupTime': formattedTime,
//     'days': selectedDays,
//     'reminderBefore': 10, // Default reminder
//   });
//
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text('Standup schedule updated!')),
//   );
//
//   // Send notification after saving the schedule
//   await sendStandupNotification();
//
//   Navigator.pop(context);
// }





// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   /// Initialize Notifications
//   Future<void> initNotifications() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("User granted permission for notifications");
//     }
//
//     // Listen for messages in foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });
//   }
//
//   void _showNotification(RemoteMessage message) async {
//     var androidDetails = AndroidNotificationDetails(
//       'standup_channel',
//       'Standup Updates',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     var notificationDetails = NotificationDetails(android: androidDetails);
//
//     await FlutterLocalNotificationsPlugin().show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       notificationDetails,
//     );
//   }
//
//   /// ✅ Subscribe users to standup notifications
//   void subscribeToStandupTopic() {
//     _firebaseMessaging.subscribeToTopic("standup_updates");
//   }
//
//   /// ✅ Send a standup notification to all users in the topic
//   Future<void> sendStandupNotification() async {
//     try {
//       await FirebaseFirestore.instance.collection('notifications').add({
//         'title': 'Standup Reminder',
//         'body': 'Your daily standup is scheduled soon!',
//         'timestamp': FieldValue.serverTimestamp(),
//         'topic': 'standup_updates',
//       });
//
//       print("Standup notification triggered successfully!");
//     } catch (e) {
//       print("Error sending notification: $e");
//     }
//   }
// }
//
//
//
//
//
//
//
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// //
// // Future<void> sendDailyReminder(String message) async {
// //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //   var androidDetails =  AndroidNotificationDetails(
// //     'daily_reminder',
// //     'Daily Standup Reminder',
// //     importance: Importance.high,
// //     priority: Priority.high,
// //   );
// //
// //   var generalNotificationDetails = NotificationDetails(android: androidDetails);
// //
// //   await flutterLocalNotificationsPlugin.show(
// //     0,
// //     'Daily Standup Reminder',
// //     message,
// //     generalNotificationDetails,
// //   );
// // }
// //
//
//
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// //
// // class NotificationService {
// //   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// //   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //   Future<void> initNotifications() async {
// //     // Request permission for notifications
// //     NotificationSettings settings = await _firebaseMessaging.requestPermission(
// //       alert: true,
// //       announcement: false,
// //       badge: true,
// //       sound: true,
// //     );
// //
// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       print("User granted permission for notifications");
// //     }
// //
// //     // Listen for messages when app is in foreground
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       _showNotification(message);
// //     });
// //   }
// //
// //   void _showNotification(RemoteMessage message) async {
// //     var androidDetails = AndroidNotificationDetails(
// //       'standup_channel',
// //       'Standup Updates',
// //       importance: Importance.high,
// //       priority: Priority.high,
// //     );
// //     var notificationDetails = NotificationDetails(android: androidDetails);
// //
// //     await _flutterLocalNotificationsPlugin.show(
// //       0,
// //       message.notification?.title,
// //       message.notification?.body,
// //       notificationDetails,
// //     );
// //   }
// //
// //   void subscribeToStandupTopic() {
// //     _firebaseMessaging.subscribeToTopic("standup_updates");
// //   }
// // }
//
//
