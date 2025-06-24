import 'package:card/app/api_manager/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/card_activity_response/card_activity_response.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class CardActivityController extends GetxController {
  ApiClient apiClient = ApiClient();
  RxBool isCardLoading = false.obs;
  RxList<CardActivityData> activityList = <CardActivityData>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getCardActivity();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Liked":
        return Colors.red;
      case "SuperLiked":
        return Colors.amber;
      case "Removed":
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Liked":
        return Icons.favorite;
      case "SuperLiked":
        return Icons.star;
      case "Removed":
        return Icons.remove_circle;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> getCardActivity() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isCardLoading.value = false;
      return;
    }
    String authToken = await SecureStorage().readSecureData("token");
    String userId = await SecureStorage().readSecureData("userId");

    print("userId====>${userId}");
    try {
      isCardLoading.value = true;

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json'
      };
      final url = "${ApiEndPoints.CARDACTIVITY}/$userId";

      Response response =
          await apiClient.getData(url, headers: header, handleError: false);
      isCardLoading.value = false;

      if (response.statusCode == 200) {
        final categoryResponse = CardActivityResponse.fromJson(response.body);
        final fetchedData = categoryResponse.data ?? [];

        activityList.assignAll(fetchedData);

        print("Category List Updated: ${activityList.length}");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e, stackTrace) {
      isCardLoading.value = false;
      print("🧵 StackTrace: $stackTrace");
    }
  }
}
