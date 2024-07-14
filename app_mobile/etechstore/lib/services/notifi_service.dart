import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificaiotnServece {
  Future<void> requestPermisstion() async {
    PermissionStatus status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {
      throw Exception("Permission no grandted");
    }
  }

  final fireStore = FirebaseFirestore.instance;
  final _currenUser = FirebaseAuth.instance.currentUser;

  Future<void> uploadFcmToken() async {
    try {
      await FirebaseMessaging.instance.getToken().then((token) async {
        print('getToken:: $token');
        await fireStore.collection('Users').doc(_currenUser!.uid).update({'token': token, 'email': _currenUser.email});
      });

      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        print('onTokenRefresh');
        await fireStore.collection("Users").doc(_currenUser!.uid).update({'token': token, 'email': _currenUser.email});
      });
    } catch (e) {
      print("Phát sinh lỗi: $e");
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    AndroidInitializationSettings AndroidinitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings = InitializationSettings(android: AndroidinitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      channelDescription: 'Change Description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: kIsWasm,
      ticker: 'ticker',
    );

    int notificationId = 1;

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: 'Not persent'
    );
  }
}
