import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.payload != null) {
          print("Notification clicked with payload: ${response.payload}");
        }
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } catch (e) {
      print("Error displaying notification: $e");
    }
  }
}
