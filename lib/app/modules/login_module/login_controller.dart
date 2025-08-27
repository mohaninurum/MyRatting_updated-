import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../api_manager/api_client.dart';
import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../routes/app_pages.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class LoginController extends GetxController {
  ApiClient apiClient = ApiClient();
  var selectedCountryCode = "+91".obs;
  var phoneNumber = "".obs;
  var country = "".obs;
  var fcmToken = "".obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = "".obs;
  FocusNode mobileNumberFocusNode = FocusNode(); // Add a FocusNode
  RxBool isGoogleLoading = false.obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
  }

  bool isPhoneNumberValid() {
    try {
      final fullNumber = '${selectedCountryCode.value}${phoneNumber.value}';
      final parsed = PhoneNumber.parse(fullNumber);
      print("FullNumber====>${fullNumber}");
      return parsed.isValid();
    } catch (_) {
      return false;
    }
  }

  final TextEditingController phoneController = TextEditingController();
  @override
  void onInit() async {
    super.onInit();

    String? savedCountryCode = await SecureStorage().readSecureData("country");
    country.value = savedCountryCode ?? "IN";

    String? savedFcmToken = await SecureStorage().readSecureData("deviceToken");
    fcmToken.value = savedFcmToken ?? "";
    print("SavedFcmToken====>${fcmToken}");
  }

  void sendOtpOnMobile() async {
    isLoading.value = true;

    // Use fast connectivity check first
    if (!AppService.checkInternetConnectivityFast()) {
      // If fast check fails, do a full check
      final isConnected = await AppService.checkInternetConnectivity();
      if (!isConnected) {
        isLoading.value = false;
        AppUtils.showSnackbarError(
          title: "No Internet",
          message: "Please check your internet connection and try again.",
          icon: Icon(Icons.wifi_off, color: Colors.white),
        );
        return;
      }
    }

    if (!isPhoneNumberValid()) {
      AppUtils.showSnackbarError(
        title: "Invalid",
        message: "Please enter a valid phone number for the selected country.",
        icon: Icon(Icons.phone_rounded, color: Colors.white),
      );
      isLoading.value = false;
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    try {
      isError.value = false;

      Map<String, dynamic> body = {
        "mobilenumber": phoneController.text,
        "countrycode": selectedCountryCode.value
      };

      print("====> SENDING LOGIN REQUEST =====");
      print("====> PHONE: ${phoneController.text}");
      print("====> COUNTRY CODE: ${selectedCountryCode.value}");

      Response response = await apiClient.postData(ApiEndPoints.LOGIN, body,
          handleError: false);
      isLoading.value = false;

      print("====> LOGIN RESPONSE RECEIVED =====");
      print("RESP : ${response.body}");
      print("RESP statusCode : ${response.statusCode}");
      print("RESP body : ${body}");

      // Check if response body is null (network error or invalid response)
      if (response.body == null || response.statusCode == 1) {
        isLoading.value = false;
        AppUtils.showSnackbarError(
          title: "Network Error",
          message:
              "Unable to connect to server. Please check your internet connection.",
        );
        return;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUtils.showSnackbarSuccess(
          title: "Success",
          message: response.body?["message"] ?? "OTP sent successfully!",
          icon: Icon(Icons.password_rounded, color: Colors.white),
        );

        print("SHUBHAMTOKEN===user/login=" + (response.body?["token"] ?? ""));

        final token = response.body?["token"] ?? "";
        await SecureStorage().writeSecureData("token", token);

        // Update API client with new token
        final apiClient = Get.find<ApiClient>();
        apiClient.setAuthToken(token);

        AppService().sendFcmToken(token, fcmToken.value);

        await Get.toNamed(Routes.OTP, arguments: {
          "otp": response.body?["otp"],
          "mobileNumber": phoneController.text,
          "countryCode": selectedCountryCode.value,
        });

        print("FcmToken===>${fcmToken}");
      } else if ([400, 401, 404, 409].contains(response.statusCode)) {
        phoneController.clear();
        isError.value = true;
        errorMessage.value =
            response.body?["message"] ?? "Something went wrong";
        AppUtils.showSnackbarError(
          title: "Something went wrong",
          message: response.body?["message"] ?? "Please try again later",
        );
      } else {
        phoneController.clear();
        errorMessage.value = response.body?["error"] ?? "Invalid OTP";
        isError.value = true;
        throw Exception(
            "Status code: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      print("====> LOGIN ERROR: $e");
      AppUtils.showSnackbarError(
        title: "Something went wrong",
        message: "Please try again later",
      );
      phoneController.clear();
      isLoading.value = false;
      isError.value = false;
      throw Exception("Send OTP Error: $e");
    }
  }

  // Method to test API connectivity
  Future<bool> testApiConnectivity() async {
    try {
      print("====> TESTING API CONNECTIVITY =====");

      // Try a simple GET request to test connectivity
      Response response = await apiClient.getData("health", handleError: false);

      print("====> CONNECTIVITY TEST RESPONSE: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 404) {
        print("====> API SERVER IS REACHABLE =====");
        return true;
      } else {
        print(
            "====> API SERVER RESPONDED WITH ERROR: ${response.statusCode} =====");
        return false;
      }
    } catch (e) {
      print("====> API CONNECTIVITY TEST FAILED: $e =====");
      return false;
    }
  }
}
