import 'dart:async';
import 'dart:io';

import 'package:card/app/api_manager/api_client.dart';
import 'package:card/app/utils/secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_manager/api_endPoints.dart';
import '../routes/app_pages.dart';
import '../utils/appUtils.dart';

class AppService {
  AppService._internal();

  static final AppService _instance = AppService._internal();

  factory AppService() => _instance;

  ApiClient apiClient = ApiClient();
  // Fast connectivity check with caching
  static bool? _lastConnectivityResult;
  static DateTime? _lastCheckTime;
  static const Duration _cacheDuration = Duration(seconds: 5);

  static Future<bool> checkInternetConnectivity() async {
    // Check cache first - return cached result if recent
    if (_lastConnectivityResult != null && _lastCheckTime != null) {
      if (DateTime.now().difference(_lastCheckTime!) < _cacheDuration) {
        return _lastConnectivityResult!;
      }
    }

    try {
      // Fast connectivity check using platform-specific methods
      var connectivityResult = await Connectivity().checkConnectivity();

      bool isConnected = connectivityResult != ConnectivityResult.none;

      // Cache the result
      _lastConnectivityResult = isConnected;
      _lastCheckTime = DateTime.now();

      return isConnected;
    } catch (e) {
      // Fallback: assume connected if connectivity check fails
      _lastConnectivityResult = true;
      _lastCheckTime = DateTime.now();
      return true;
    }
  }

  // Ultra-fast connectivity check (no async, uses cached result)
  static bool checkInternetConnectivityFast() {
    if (_lastConnectivityResult != null && _lastCheckTime != null) {
      if (DateTime.now().difference(_lastCheckTime!) < _cacheDuration) {
        return _lastConnectivityResult!;
      }
    }
    return true; // Assume connected if no recent check
  }

  // Force refresh connectivity status
  static Future<bool> refreshInternetConnectivity() async {
    _lastConnectivityResult = null;
    _lastCheckTime = null;
    return await checkInternetConnectivity();
  }

  // Check if your specific API server is reachable
  static Future<bool> checkApiServerConnectivity() async {
    try {
      // Quick ping to your API server
      final result = await InternetAddress.lookup('swiperanks.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Ultra-fast API server check (cached)
  static bool? _lastApiServerResult;
  static DateTime? _lastApiServerCheckTime;
  static const Duration _apiServerCacheDuration = Duration(seconds: 10);

  static bool checkApiServerConnectivityFast() {
    if (_lastApiServerResult != null && _lastApiServerCheckTime != null) {
      if (DateTime.now().difference(_lastApiServerCheckTime!) <
          _apiServerCacheDuration) {
        return _lastApiServerResult!;
      }
    }
    return true; // Assume reachable if no recent check
  }

  // Start background connectivity monitoring
  static void startConnectivityMonitoring() {
    Timer.periodic(Duration(seconds: 30), (timer) async {
      try {
        await checkInternetConnectivity();
        await checkApiServerConnectivity();
      } catch (e) {
        // Silent fail for background monitoring
      }
    });
  }

  // Stop background connectivity monitoring
  static void stopConnectivityMonitoring() {
    // Timer will be garbage collected automatically
  }

  void userSessionExpire() async {
    await SecureStorage().deleteAllData();
    Get.offAllNamed(Routes.SPLASH);
    AppUtils.showSnackbarError(
        title: "Session Expire",
        message: "Please login again",
        icon: Icon(Icons.hourglass_empty_outlined, color: Colors.white));
  }

  void sendFcmToken(String authToken, String FcmToken) async {
    print("FCM TOKEN IN BODY ======>${FcmToken}");
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      return;
    }
    try {
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json", // <<== Correct here
      };
      Map<String, dynamic> body = {"fcm_token": FcmToken};
      print("TOken Body======>${body}");
      Response response = await apiClient.postData(ApiEndPoints.TOKEN, body,
          headers: header, handleError: false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Successsfully calll AppServiceee");
      } else {
        print("In Else");
      }
    } catch (e) {
      //AppUtils.showSnackbarError(title: "Something went wrong",message:"Please try again later");
      throw Exception("On Catch When try to login $e");
    }
  }

  static String getCountryCodeFromLocale() {
    final locale = Platform.localeName;
    if (locale.contains('_')) {
      return locale.split('_').last;
    }
    return 'Unknown';
  }
}
