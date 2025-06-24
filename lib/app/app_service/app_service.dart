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
  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      AppUtils.showSnackbarError(
        title: "No Internet",
        message: "You're offline. Please check your internet connection.",
        icon: Icon(Icons.wifi_off, color: Colors.white),
      );
      return false;
    }
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      AppUtils.showSnackbarError(
        title: "No Internet Access",
        message: "Connected to a network but no internet access.",
        icon: Icon(Icons.wifi_off, color: Colors.white),
      );
      return false;
    }
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
