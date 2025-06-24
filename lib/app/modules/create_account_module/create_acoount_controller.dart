import 'package:card/app/api_manager/api_client.dart';
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
      print("in try");
      await googleSignIn.signIn().then((value) {
        if (value != null) {
          debugPrint("User signed in: ${value.displayName}, ${value.email}");
          print("Enter====>$value");

          googleLogin(
            value.id,
            value.displayName ?? "",
            value.email ?? "",
          );
        } else {
          debugPrint("Sign in was null");
          isGoogleLoading(false);
        }
      }).onError((error, stackTrace) {
        debugPrint("$error");
        print("In google sign-in API");
        debugPrint("Catch error: $error");
        isGoogleLoading(false);
      });
    } catch (error, stacktrace) {
      isGoogleLoading.value = false;
      debugPrint("Catch error: $error");
      print("Stacktrace====>${stacktrace}");
      debugPrint(error.toString());
    }
  }

  void googleLogin(String userId, String firstName, String email) async {
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
    if (await googleSignIn.isSignedIn()) {
      print("User already signed in, signing out first...");
      await googleSignIn.signOut();
    }
    try {
      Map<String, dynamic> body = {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        await SecureStorage().writeSecureData("token", response.body["token"]);
        await SecureStorage().writeSecureData("userId", response.body["userId"].toString());
        /* final token = data["token"];
        final userId = data["userId"].toString();*/
        final isAuthorized = data["is_authorize"];

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
          message: response.body["message"] ?? "Please try again later.",
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
