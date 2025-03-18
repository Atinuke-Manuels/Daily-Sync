import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize Notifications
  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications");
    }

    // Listen for messages in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  void _showNotification(RemoteMessage message) async {
    var androidDetails = AndroidNotificationDetails(
      'standup_channel',
      'Standup Updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);

    await FlutterLocalNotificationsPlugin().show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  /// ✅ Subscribe users to standup notifications
  void subscribeToStandupTopic() {
    _firebaseMessaging.subscribeToTopic("standup_updates");
  }

  /// ✅ Send a standup notification to all users in the topic
  Future<void> sendStandupNotification() async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': 'Standup Reminder',
        'body': 'Your daily standup is scheduled soon!',
        'timestamp': FieldValue.serverTimestamp(),
        'topic': 'standup_updates',
      });

      print("Standup notification triggered successfully!");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}







// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// Future<void> sendDailyReminder(String message) async {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   var androidDetails =  AndroidNotificationDetails(
//     'daily_reminder',
//     'Daily Standup Reminder',
//     importance: Importance.high,
//     priority: Priority.high,
//   );
//
//   var generalNotificationDetails = NotificationDetails(android: androidDetails);
//
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'Daily Standup Reminder',
//     message,
//     generalNotificationDetails,
//   );
// }
//


// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotifications() async {
//     // Request permission for notifications
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
//     // Listen for messages when app is in foreground
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
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       notificationDetails,
//     );
//   }
//
//   void subscribeToStandupTopic() {
//     _firebaseMessaging.subscribeToTopic("standup_updates");
//   }
// }


