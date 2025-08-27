import 'package:card/app/api_manager/api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../routes/app_pages.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class CreateAccountController extends GetxController {
  RxBool isGoogleLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  var fcmToken = "".obs;

  @override
  void onInit() async {
    super.onInit();
    String? savedFcmToken = await SecureStorage().readSecureData("deviceToken");
    fcmToken.value = savedFcmToken ?? "";
    print("SavedFcmToken====>${fcmToken}");
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  ApiClient apiClient = ApiClient();

  Future<void> handleSignIn() async {
    isGoogleLoading.value = true;
    try {
      print("Attempting Google Sign-In...");
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("SUser cancelled Google Sign-In");
        isGoogleLoading.value = false;
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint(
          "User signed in: ${googleUser.displayName}, ${googleUser.email}");

      googleLogin(
        googleUser.id,
        googleUser.displayName ?? "",
        googleUser.email ?? "",
      );
    } catch (error, stackTrace) {
      isGoogleLoading.value = false;
      debugPrint("Sign-In error: $error");
      print("StackTrace: $stackTrace");
    }
  }

  void googleLogin(String userId, String firstName, String email) async {
    try {
      isLoading.value = true;

      final isConnected = await AppService.checkInternetConnectivity();
      if (!isConnected) {
        isLoading.value = false;
        AppUtils.showSnackbarError(
          title: "No Internet",
          message: "Please check your internet connection.",
        );
        return;
      }

      final body = {
        "uId": userId,
        "login_type": "Google",
        "fullname": firstName,
        "email": email,
      };

      final response = await apiClient.postData(
        ApiEndPoints.SOCIALOGIN,
        body,
        handleError: false,
      );

      isLoading.value = false;

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
        final data = response.body;

        if (data?["token"] != null && data?["userId"] != null) {
          await SecureStorage().writeSecureData("token", data["token"]);
          await SecureStorage()
              .writeSecureData("userId", data["userId"].toString());
        } else {
          throw Exception("Missing token or userId in response");
        }

        final isAuthorized = data["is_authorize"];
        print("IsAuthorized value ::: $isAuthorized");
        //  Get.find<AppService>().sendFcmToken(token, fcmToken.value);

        if (isAuthorized == 0) {
          Get.toNamed(
            Routes.TERMCONDITION,
            arguments: {
              "mobile": "",
              "type": "google",
              "firstName": firstName,
              "lastName": "",
              "email": email,
            },
          );
        } else {
          Get.offAllNamed(Routes.CATEGORY);
        }
      } else if ([400, 401, 404, 409].contains(response.statusCode)) {
        isError.value = true;
        AppUtils.showSnackbarError(
          title: "Login Failed",
          message: response.body?["message"] ?? "Please try again later.",
        );
      } else {
        isError.value = true;
        throw Exception(
            "Unexpected status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      AppUtils.showSnackbarError(
        title: "Error",
        message: "Google login failed. Try again later.",
      );
      print("Google Login Error: $e");
    }
  }
}
