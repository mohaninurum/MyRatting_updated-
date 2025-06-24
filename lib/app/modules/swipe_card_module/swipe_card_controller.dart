import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:card/app/api_manager/api_client.dart';
import 'package:card/app/modules/card_activity_module/card_activity_controller.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/get_card_response/get_card_response.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

final EventBus eventBus = EventBus();

class NewCardEvent {}

class SwipeCardController extends GetxController {
  ApiClient apiClient = ApiClient();
  RxBool isLiked = false.obs;
  RxBool isDisLiked = false.obs;
  RxBool isSuperLike = false.obs;
  List<SwipeItem> swipeItems = [];
  MatchEngine? matchEngine;
  RxBool isLoader = false.obs;
  RxBool isAutoSkip = false.obs;
  RxList<CardData> subCategoryList = <CardData>[].obs;
  RxBool isCard = false.obs;
  var showRewindButton = false.obs;
  var allCardsSwiped = false.obs;
  var currentCardIndex = 0.obs;
  var currentImageIndex = 0.obs;
  var timer;

  RxnInt selectedCategoryId = RxnInt();
  RxList<int> selectedSubcategoryIds = <int>[].obs;
  final storage = FlutterSecureStorage();
  late StreamSubscription newCardEventSub;
  final AppLinks appLinks = AppLinks();

  @override
  void onInit() {
    super.onInit();
    getCard();

    newCardEventSub = eventBus.on<NewCardEvent>().listen((event) {
      timer?.cancel();
      print("New card event received");
      getCard();
      update();
    });
  }

  List<String> parseImages(String rawImage) {
    try {
      if (!rawImage.contains('[')) return [];

      final match = RegExp(r'\[(.*?)\]').firstMatch(rawImage);
      if (match == null) return [];

      final listString = '[${match.group(1)}]';
      final List<dynamic> decoded = jsonDecode(listString);

      return decoded
          .whereType<String>()
          .map((img) => "http://myephysician.com/myratingsystem/uploads/icons/$img")
          .toList();
    } catch (e) {
      print("Image parse error: $e");
      return [];
    }
  }

  Future<void> getCard() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isCard.value = false;
      return;
    }
    update();
    timer?.cancel();
    String authToken = await SecureStorage().readSecureData("token");
    String? filtersJson = await SecureStorage().readSecureData("filters");

    if (filtersJson == null || filtersJson.isEmpty) {
      print("No filters found in secure storage");
      isCard.value = false;
      return;
    }
    update();
    Map<String, dynamic> filterData = jsonDecode(filtersJson);
    List<Map<String, dynamic>> filters = [];

    if (filterData["filters"] is List) {
      filters = (filterData["filters"] as List)
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    print("Sending filters payload: ${jsonEncode({"filters": filters})}");

    Map<String, String> header = {
      "Authorization": "Bearer $authToken",
      "Content-Type": "application/json",
    };
    final body = {
      "filters": filters,
    };

    try {
      isCard.value = true;
      final String url = ApiEndPoints.CARD;

      Response response = await apiClient.postData(
        url,
        body,
        headers: header,
        handleError: false,
      );

      print("GetCard RESPONSE : ${response.body}");

      if (response.statusCode == 200) {
        final cardResponse = GetCardResponse.fromJson(response.body);
        final fetchedData = cardResponse.data ?? [];
        final validCards = fetchedData.where((card) => card.status == 2).toList();

        subCategoryList.assignAll(validCards);

        swipeItems = validCards
            .map((card) {
              final imageList = parseImages(card.image ?? "");
              if (imageList.isEmpty) return null;

              return SwipeItem(
                content: imageList,
                likeAction: () {
                  likeApi(card.card_id_PK.toString());
                },
                nopeAction: () {
                  disLikeApi(card.card_id_PK.toString());
                },
              );
            })
            .whereType<SwipeItem>()
            .toList();

        if (swipeItems.isNotEmpty) {
          matchEngine = MatchEngine(swipeItems: swipeItems);
          // startImageChangeTimer();
        }

        isCard.value = false;
        update();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
        update();
        isCard.value = false;
      }
    } catch (e) {
      isCard.value = false;
      update();
      print("Error in getCard: $e");
    }
  }

  void startImageChangeTimer() {
    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (currentCardIndex.value >= swipeItems.length) {
        timer.cancel();
        return;
      }

      final images = swipeItems[currentCardIndex.value].content;

      if (currentImageIndex.value < images.length - 1) {
        currentImageIndex.value++;
      } else {
        if (swipeItems.isNotEmpty) {
          skipCardSilently();
        } else {
          timer.cancel();
          return;
        }
      }

      update();
    });
  }

  void skipCardSilently() {
    if (currentCardIndex.value >= swipeItems.length) return;

    swipeItems.removeAt(currentCardIndex.value);
    subCategoryList.removeAt(currentCardIndex.value);

    currentImageIndex.value = 0;
    matchEngine = MatchEngine(swipeItems: swipeItems);
    if (swipeItems.isEmpty) {
      getCard();
    }
    update();
  }

  // void rewindCards() {
  //   if (swipeItems.isEmpty) return;
  //
  //   timer?.cancel(); // Stop the current timer if running
  //
  //   currentCardIndex.value = 0;
  //   currentImageIndex.value = 0;
  //   allCardsSwiped.value = false;
  //
  //   matchEngine = MatchEngine(swipeItems: swipeItems); // Reset engine
  //   //startImageChangeTimer(); // Restart timer
  //   update(); // Refresh UI
  // }

  void rewindPreviousCard(index) {
    if (index > 0) {
      currentCardIndex.value = index-1;
      currentImageIndex.value = index-1;
      print("index ${index} : ${currentCardIndex.value} : ${currentImageIndex.value}");

    } else {
      // If we're on the first card, do nothing or move to the last card if desired
      print('Already at the first card');
    }
    update(); // Update the UI to reflect the change
  }

  void rewindAllCards() {
    currentCardIndex.value = 0;
    currentImageIndex.value = 0;
    update();
  }

  void onAllCardsSwiped() {
    showRewindButton.value = false;
    allCardsSwiped.value = true;
    update(); // Update the UI to reflect the change
  }

  Future<void> likeApi(String cardId) async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoader.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");
    try {
      isLoader.value = true;
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> body = {"cardId": cardId};

      Response response = await apiClient.postData(
        ApiEndPoints.LIKE,
        body,
        headers: header,
        handleError: false,
      );

      isLoader.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        /* AppUtils.showSnackbarSuccess(
          title: "Liked",
          message: response.body["message"] ?? "Liked successfully",
          icon: Icon(Icons.favorite, color: Colors.white)
        );*/

        CardActivityController cardController = Get.find<CardActivityController>();
        cardController.getCardActivity();
        cardController.update();
      } else if (response.statusCode == 400) {
        /*   AppUtils.showSnackbarError(
          title: "Failed",
          message: response.body["message"] ?? "Already Liked",
          icon: Icon(Icons.favorite, color: Colors.white)
        );*/
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isLoader.value = false;
      print("Error in likeApi: $e");
    }
  }

  Future<void> disLikeApi(String cardId) async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoader.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");
    try {
      isLoader.value = true;
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> body = {"cardId": cardId};

      Response response = await apiClient.postData(
        ApiEndPoints.DISLIKE,
        body,
        headers: header,
        handleError: false,
      );

      isLoader.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        /*  AppUtils.showSnackbarError(
          title: "Dislike",
          message: response.body["message"] ?? "DisLiked successfully",
          icon: Icon(Icons.thumb_down, color: Colors.white)
        );
*/

        CardActivityController cardController = Get.find<CardActivityController>();
        cardController.getCardActivity();
        cardController.update();
      } else if (response.statusCode == 400) {
        /* AppUtils.showSnackbarError(
          title: "Failed",
          message: response.body["message"] ?? "Already DisLiked",
          icon: Icon(Icons.thumb_down, color: Colors.white)
        );*/
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isLoader.value = false;
      print("Error in disLikeApi: $e");
    }
  }

  Future<void> superLikeApi(String cardId) async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoader.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");
    try {
      isLoader.value = true;
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };
      Map<String, dynamic> body = {"cardId": cardId};

      Response response = await apiClient.postData(
        ApiEndPoints.SUPERLIKE,
        body,
        headers: header,
        handleError: false,
      );

      isLoader.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        /*AppUtils.showSnackbarSuccess(
          title: "Super Liked",
          message: response.body["message"] ?? "SuperLiked successfully",
          icon: Icon(Icons.star, color: Colors.white)
        );*/

        CardActivityController cardController = Get.find<CardActivityController>();
        cardController.getCardActivity();
        cardController.update();
      } else if (response.statusCode == 400) {
        /* AppUtils.showSnackbarError(
          title: "Failed",
          message: response.body["message"] ?? "Already SuperLiked",
          icon: Icon(Icons.star, color: Colors.white)
        );*/
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isLoader.value = false;
      print("Error in superLikeApi: $e");
    }
  }

  @override
  void dispose() {
    Get.delete<SwipeCardController>(); // This will trigger onClose()
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel(); // Cancel timer when controller is disposed
  }
}
