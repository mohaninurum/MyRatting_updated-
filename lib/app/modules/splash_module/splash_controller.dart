import 'package:app_links/app_links.dart';
import 'package:card/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("Splash Screen Started"); // Debugging
    Future.delayed(const Duration(seconds: 3), () {
      print("Navigating to Create Account"); // Debugging
      Get.offAllNamed(Routes.CREATE_ACOOUNT);
    });
  }
}
*/
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _handleInitialDeepLink();
  }

  Future<void> _handleInitialDeepLink() async {
    final appLinks = AppLinks();
    Uri? initialUri;

    try {
      initialUri = await appLinks.getInitialLink();
    } catch (e) {
      print("Error retrieving initial deep link: $e");
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialUri != null) {
        final cardId = initialUri.queryParameters['cardId'];
        if (cardId != null) {
          Get.offAllNamed(Routes.CARD_DETAIL, arguments: {'cardId': cardId});
          return;
        }
      }

      Get.offAllNamed(Routes.CREATE_ACOOUNT);
    });
  }
}
