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
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/app_service/app_service.dart';
import 'app/api_manager/api_client.dart';
import 'app/modules/swipe_card_module/swipe_card_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/local_notificationService.dart';
import 'app/services/notification_service.dart';
import 'firebase_options.dart';

Uri? initialDeepLink;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();

  // // Configure test devices for development
  // MobileAds.instance.updateRequestConfiguration(
  //   RequestConfiguration(
  //     testDeviceIds: ['TEST_DEVICE_ID'], // Add your test device ID here
  //   ),
  // );

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

    // Initialize API client with stored token
    final apiClient = Get.put(ApiClient());
    if (token != null && token!.isNotEmpty) {
      apiClient.setAuthToken(token);
      print("API Client initialized with stored token");
    }

    // Start background connectivity monitoring
    AppService.startConnectivityMonitoring();
    print("Connectivity monitoring started");

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
        fontFamily: 'Roboto', // Use system font to avoid network issues
      ),
    );
  }
}
