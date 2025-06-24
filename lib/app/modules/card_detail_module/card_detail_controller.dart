import 'dart:async';
import 'dart:convert';

import 'package:card/app/api_manager/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/card_detail_response/card_detail.dart';
import '../../utils/appUtils.dart';

class CardDetailController extends GetxController {
  ApiClient apiClient = ApiClient();

  var currentIndex = 0.obs;
  late PageController pageController;
  late Timer _timer;

  RxString cardId = "".obs;
  RxBool isLoading = false.obs;
  CardDetailData? cardDetailData;
  List<String> images = [];

  @override
  void onInit() {
    super.onInit();
    cardId.value = Get.arguments["cardId"];
    pageController = PageController();
    getCardDetail();
  }

  /// Parse raw image string like: "http://.../uploads/icons/[\"img1.jpg\", \"img2.jpg\"]"
  List<String> parseImages(String rawImage) {
    try {
      final startIndex = rawImage.indexOf('[');
      final endIndex = rawImage.indexOf(']') + 1;

      if (startIndex == -1 || endIndex == -1) return [];

      final jsonArray = rawImage.substring(startIndex, endIndex);
      final List<dynamic> decodedList = jsonDecode(jsonArray);

      return decodedList
          .map((img) => "http://myephysician.com/myratingsystem/uploads/icons/$img")
          .toList();
    } catch (e) {
      print("Image parsing failed: $e");
      return [];
    }
  }

  void _startAutoScroll() {
    if (images.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentIndex.value < images.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }

      pageController.animateToPage(
        currentIndex.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void getCardDetail() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final url = "${ApiEndPoints.CARD_DETAIL}/${cardId.value}";
      final response = await apiClient.getData(url, handleError: false);
      isLoading.value = false;
      if (response.statusCode == 200) {
        final parsed = CardDetailResponse.fromJson(response.body);
        print("-----------------------------");
        print("CARD DATA BODY: ${response.body}");
        print("CARD DATA parsed: ${jsonEncode(parsed)}");
        print("-----------------------------");
        if (parsed.data != null && parsed.data!.isNotEmpty) {
          cardDetailData = parsed.data!.first;

          final rawImage = cardDetailData?.image ?? '';
          images = parseImages(rawImage);

          _startAutoScroll();
          update();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      } else {
        AppUtils.showSnackbarError(
          title: "Error",
          message: response.body["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      isLoading.value = false;
      AppUtils.showSnackbarError(
        title: "Something went wrong",
        message: "Please try again later.",
      );
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    pageController.dispose();
    super.onClose();
  }
}
