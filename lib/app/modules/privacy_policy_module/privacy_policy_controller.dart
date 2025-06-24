import 'dart:convert';

import 'package:card/app/api_manager/api_client.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class PrivacyPolicyController extends GetxController {
  ApiClient apiClient = ApiClient();
  RxBool isLoading = false.obs;
  var content = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPrivacy();
  }

  Future<void> getPrivacy() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");

    try {
      isLoading.value = true;

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };

      Response response = await apiClient.getData(
        ApiEndPoints.PRIVACY_POLICY,
        headers: header,
        handleError: false,
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = response.body["data"];

        if (data != null && data["content"] != null) {
          content.value = data["content"];
        } else {
          print("Unexpected response format: ${response.body}");
        }

        print("Response ===> ${response.body}");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isLoading.value = false;
      print("Error fetching privacy policy: $e");
    }
  }
}
