import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'utils/app_route.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:'This channel is used for important notifications.', // description
    importance: Importance.max);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('background message ${message.notification?.body}');
}

class FirebaseApp {
  Future<void> initFirebase(BuildContext context) async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/app_icon');

      const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid,);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (payload) =>selectNotification(context, payload));

      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true, );

      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {if (message != null) { Navigator.pushReplacementNamed(context, Routes.mainScreen, arguments: 2);} });
      
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        Navigator.pushReplacementNamed(context, Routes.mainScreen, arguments: 2);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: const Color(0xFF54B1A8)
                ),
              ));
        }
      });

      FirebaseMessaging.instance.subscribeToTopic("global");
    }
  }
}

void selectNotification(BuildContext context, String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  Navigator.pushReplacementNamed(context, Routes.mainScreen, arguments: 2);
}
