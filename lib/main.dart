/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Permission.notification.request();
  tz.initializeTimeZones();

  await FirebaseAnalytics.instance.logAppOpen();

  NotificationService().initNotification();
  LocalNotificationService.initialize();
  appLinks.getInitialLink();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notificationTitle = message.notification?.title;
    if (notificationTitle == 'New Card Available') {
      eventBus.fire(NewCardEvent());
    }

    LocalNotificationService.createanddisplaynotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen(LocalNotificationService.createanddisplaynotification);

  requestNotificationPermission();

  Get.put(AppService());

  final token = await SecureStorage().readSecureData('token');
  final fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken != null) {
    await SecureStorage().writeSecureData("deviceToken", fcmToken);
    if (token != null) {
      Get.find<AppService>().sendFcmToken(token, fcmToken);
    }
  }

  final countryCode = AppService.getCountryCodeFromLocale();
  await SecureStorage().writeSecureData("country", countryCode);

  runApp(MyApp(token: token));
}*/
import 'package:app_links/app_links.dart';
import 'package:card/app/modules/splash_module/splash_page.dart';
import 'package:card/app/utils/secure_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app/app_service/app_service.dart';
import 'app/modules/swipe_card_module/swipe_card_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/local_notificationService.dart';
import 'app/services/notification_service.dart';
import 'firebase_options.dart';

Uri? initialDeepLink;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Permission.notification.request();
  tz.initializeTimeZones();
  await FirebaseAnalytics.instance.logAppOpen();

  NotificationService().initNotification();
  LocalNotificationService.initialize();
  requestNotificationPermission();
  try {
    final appLinks = AppLinks();
    initialDeepLink = await appLinks.getInitialLink();
    print("Initial deep link: $initialDeepLink");
  } catch (e) {
    print("Error getting initial deep link: $e");
  }
  //Get.put(AppService());
  //Get.put(CardActivityController());
  String? token;
  try {
    token = await SecureStorage().readSecureData('token');
    print("LINE 86 : $token");
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await SecureStorage().writeSecureData("deviceToken", fcmToken);
      if (token != null) {
        AppService().sendFcmToken(token, fcmToken);
      }
    }
  } catch (ERROR) {
    print("ERROR ::: $ERROR");
  }

  final countryCode = AppService.getCountryCodeFromLocale();
  await SecureStorage().writeSecureData("country", countryCode);

  // FCM listeners
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notificationTitle = message.notification?.title;
    if (notificationTitle == 'New Card Available') {
      eventBus.fire(NewCardEvent());
    }
    LocalNotificationService.createanddisplaynotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen(
    LocalNotificationService.createanddisplaynotification,
  );

  runApp(MyApp(token: token));
}

Future<void> requestNotificationPermission() async {
  await Permission.notification.request();
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

    final isLoggedIn = token != null && token!.isNotEmpty;

    return GetMaterialApp(
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => SplashPage(),
      ),
      initialRoute: isLoggedIn ? Routes.DASHBOARD : Routes.SPLASH,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
