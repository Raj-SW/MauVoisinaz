// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, deprecated_member_use

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final notificationPlugins = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('flutter_logo');
    DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (id, title, body, payload) {});
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);
    await notificationPlugins.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  Future<void> showSimpleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("Channel_id", "Channel_title",
            priority: Priority.max,
            importance: Importance.max,
            groupKey: 'commonMessage');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationPlugins.show(1, "Simple Notification Title",
        "Simple Notification Body", notificationDetails);
  }

  Future<void> showSimpleBroadCast(String name) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("Channel_id", "Channel_title",
            priority: Priority.max,
            importance: Importance.max,
            groupKey: 'commonMessage');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationPlugins.show(1, "A Distress Call has been Raised!!!",
        "$name is unsafe ", notificationDetails);
  }
}
