import 'package:card/app/api_manager/api_client.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../routes/app_pages.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class TermConditionController extends GetxController {
  ApiClient apiClient =ApiClient();
  var content = "".obs;
  RxBool isChecked = false.obs;
  RxBool isLoading = false.obs;
  var mobile = "".obs;
  var countryCode = "".obs;
  var email = "".obs;
  var firstName = "".obs;
  var lastName = "".obs;
  var loginType = "".obs;
  @override

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    loginType.value = args["type"] ?? "";

    if (loginType.value == "google") {
      email.value = args["email"] ?? "";
      firstName.value = args["firstName"] ?? "";
      lastName.value = args["lastName"] ?? "";
      mobile.value = args["mobile"] ?? ""; // might be blank or optional
    } else if (loginType.value == "phone") {
      mobile.value = args["mobile"] ?? "";
      countryCode.value = args["countryCode"] ?? "";
    }

    print("Login type: $loginType");
    getTermsCondition();
  }

  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }


  void proceedIfAgreed() {
    if (isChecked.value) {
      final arguments = {
        "mobile": mobile.value,
        "countryCode":countryCode.value,
        "loginType": loginType.value,
      };

      if (loginType.value == "google") {
        arguments.addAll({
          "email": email.value,
          "firstName": firstName.value,
          "lastName": lastName.value,
        });
      }

      Get.toNamed(Routes.SUBMIT_DETAIL, arguments: arguments);
    }
  }

  Future<void> getTermsCondition() async {
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
        ApiEndPoints.TERMS_CONDITION,
        headers: header,
        handleError: false,
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        if (response.body is Map<String, dynamic> && response.body["content"] != null) {
          content.value = response.body["content"];
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
