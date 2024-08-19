import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  bool? isPermission;

  // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  Future<bool> requestNotificationPermission() async {
    if (Platform.isIOS) {
      await messaging.requestPermission(alert: true, announcement: true, badge: true, carPlay: true, criticalAlert: true, provisional: true, sound: true);
    }

    NotificationSettings notificationSettings = await messaging.requestPermission(alert: true, announcement: true, badge: true, carPlay: true, criticalAlert: true, provisional: true, sound: true);

    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User is already granted permisions");
      return true;
    } else if (notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User is already granted provisional permisions");
      return true;
    } else {
      print("User has denied permission");
      return false;
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }
}
