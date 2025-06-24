import 'package:card/app/api_manager/api_client.dart';
import 'package:card/app/routes/app_pages.dart';
import 'package:card/app/utils/appUtils.dart';
import 'package:card/app/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';

class SubmitDetailController extends GetxController {
  ApiClient apiClient = ApiClient();

  var firstNameController = TextEditingController();
  var lasttNameController = TextEditingController();
  var numberController = TextEditingController();
  var emailController = TextEditingController();
  var selectedBirthDate = Rxn<DateTime>(); // Nullable reactive date
  var selectedAge = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = "".obs;
  var country = "".obs;
  var mobile = "".obs;
  var phoneNumber = "".obs;
  var loginType = "".obs;
  var isPhoneEditable = true.obs;
  var isEmailEditable = true.obs;
  var selectedCountryCode = "+91".obs;
  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
  }

  bool isPhoneNumberValid() {
    try {
      final fullNumber = '${selectedCountryCode.value}${phoneNumber.value}';
      final parsed = PhoneNumber.parse(fullNumber);
      return parsed.isValid();
    } catch (_) {
      return false;
    }
  }

  final TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    loginType.value = args["loginType"] ?? "";
    mobile.value = args["mobile"] ?? "";
    phoneController.text = mobile.value;
    selectedCountryCode.value = args["countryCode"];
    if (loginType.value == "google") {
      firstNameController.text = args["firstName"] ?? "";
      lasttNameController.text = args["lastName"] ?? "";
      emailController.text = args["email"] ?? "";

      isEmailEditable.value = false;
      isPhoneEditable.value = true;
    } else if (loginType.value == "phone") {
      isPhoneEditable.value = false;
      isEmailEditable.value = true;
    }
  }

  final List<int> ageList = List.generate(88, (index) => 13 + index);

  void register() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
    }

    if (!checkField()) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      isLoading.value = true;
      isError.value = false;

      Map<String, dynamic> body = {
        "fullname": firstNameController.text,
        "mobilenumber": phoneController.text,
        "age": DateFormat('yyyy-MM-dd').format(selectedBirthDate.value!),
        "email": emailController.text,
      };
      print("CounryCOde====>${selectedCountryCode.value}");
      String token = await SecureStorage().readSecureData("token");
      print("TOKEN====>${token}");

      Map<String, String> headers = {
        "Authorization":"Bearer $token",
      "Content-Type":"application/json"};
      Response response =
          await apiClient.postData(ApiEndPoints.REGISTER, body,headers: headers, handleError: false);

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUtils.showSnackbarSuccess(
          title: "Success",
          message: response.body["message"] ?? "Registered successfully!",
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        print("SHUBHAMTOKEN===user/register=" + response.body["token"]);
        await SecureStorage().writeSecureData("token", response.body["token"]);
        await SecureStorage()
            .writeSecureData("userId", response.body["userId"].toString());

        await Get.offAllNamed(Routes.CATEGORY);

        var token = response.body["token"];
        String fcmToken = await SecureStorage().readSecureData("deviceToken");
        AppService().sendFcmToken(token, fcmToken);
      } else if (response.statusCode == 400) {
        clearFields();
        isError.value = true;
        errorMessage.value = response.body["error"];
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      } else if (response.statusCode == 404 || response.statusCode == 409) {
        AppUtils.showSnackbarError(
          title: "Something went wrong",
          message: response.body["message"] ?? "Please try again later",
        );
      } else {
        clearFields();
        errorMessage.value = response.body["error"] ?? "Invalid Mobile Number";
        isError.value = true;
        throw Exception(
            "Register failed with status code ${response.statusCode}\nBody: ${response.body}");
      }
    } catch (e) {
      AppUtils.showSnackbarError(
        title: "Something went wrong",
        message: "Please try again later",
      );

      //clearFields();
      isLoading.value = false;
      isError.value = false;
      throw Exception("Register exception: $e");
    }
  }

  bool checkField() {
    if (firstNameController.text.isEmpty) {
      AppUtils.showSnackbarError(
        title: "Invalid",
        message: "Please enter Full Name",
        icon: Icon(Icons.person, color: Colors.white),
      );
      return false;
    }

    /*  if (lasttNameController.text.isEmpty) {
      AppUtils.showSnackbarError(
        title: "Invalid",
        message: "Please enter Last Name",
        icon: Icon(Icons.person, color: Colors.white),
      );
      return false;
    }*/

    if (phoneController.text.isEmpty || phoneController.text.length != 10) {
      AppUtils.showSnackbarError(
        title: "Invalid",
        message: "Please enter a valid 10-digit Phone Number",
        icon: Icon(Icons.phone_rounded, color: Colors.white),
      );
      return false;
    }

    if (emailController.text.isEmpty) {
      AppUtils.showSnackbarError(
        title: "Invalid",
        message: "Please enter Email",
        icon: Icon(Icons.mail, color: Colors.white),
      );
      return false;
    }

    print("All fields are valid!");
    return true;
  }

  void clearFields() {
    numberController.clear();
    emailController.clear();
    firstNameController.clear();
    lasttNameController.clear();
  }
}
