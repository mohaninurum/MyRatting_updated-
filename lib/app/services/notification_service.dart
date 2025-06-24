import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/secure_storage.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    final androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidSettings);

    try {
      await notificationsPlugin.initialize(initSettings);
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("fcmToken: $fcmToken");
      await SecureStorage().writeSecureData("deviceToken", "$fcmToken");
    } catch (err) {
      print("ERR : $err");
    }
  }
}
