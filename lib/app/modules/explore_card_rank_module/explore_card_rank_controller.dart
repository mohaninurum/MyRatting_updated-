import 'package:card/app/api_manager/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/top_rated_response/top_rated_response.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class ExploreCardController extends GetxController {
  final ApiClient apiClient = ApiClient();

  var subCtegoryId = "".obs;
  RxBool isCard = false.obs;
  RxList<TopData> topList = <TopData>[].obs;

  // /*
  //   final List<Map<String, dynamic>> cards = [
  //     {
  //       "item": "Tea",
  //       "image": 'assets/images/refreshment-9368874_640.jpg',
  //       "rank": "Rank 1",
  //       "popularity": 0.9,
  //     },
  //     {
  //       "item": "Chips",
  //       "image": 'assets/images/refreshment-9368874_640.jpg',
  //       "rank": "Rank 2",
  //       "popularity": 0.75,
  //     },
  //     {
  //       "item": "Banana Chips",
  //       "image": 'assets/images/refreshment-9368874_640.jpg',
  //       "rank": "Rank 3",
  //       "popularity": 0.6,
  //     },
  //     {
  //       "item": "Pizza",
  //       "image": 'assets/images/refreshment-9368874_640.jpg',
  //       "rank": "",
  //       "popularity": 0.45,
  //     },
  //     {
  //       "item": "Fries",
  //       "image": 'assets/images/refreshment-9368874_640.jpg',
  //       "rank": "",
  //       "popularity": 0.38,
  //     },
  //   ];
  // */Dummy local card list

  //List<Map<String, dynamic>> get allCards => cards;

  @override
  void onInit() {
    super.onInit();
    subCtegoryId.value = Get.arguments["subCategoryId"] ?? "";
    getTopCard();
  }

  Future<void> getTopCard() async {
    try {
      final isConnected = await AppService.checkInternetConnectivity();
      if (!isConnected) {
        isCard.value = false;
        return;
      }

      isCard.value = true;

      final authToken = await SecureStorage().readSecureData("token");

      final url = "${ApiEndPoints.TOPRATED}/${subCtegoryId.value}";
      final headers = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json",
      };

      final response = await apiClient.getData(url, headers: headers, handleError: false);
      isCard.value = false;

      if (response.statusCode == 200) {
        final topResponse = TopRatedResponse.fromJson(response.body);
        final fetchedData = topResponse.data ?? [];
        topList.assignAll(fetchedData);
        print("Top cards fetched: ${topList.length}");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      } else {
        print("Failed to fetch top cards. Status: ${response.statusCode}");
      }
    } catch (e) {
      isCard.value = false;
      print("Error fetching top cards: $e");
    }
  }
}


