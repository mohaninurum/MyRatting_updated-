import 'package:card/app/api_manager/api_client.dart';
import 'package:card/app/modules/login_module/login_controller.dart';
import 'package:card/app/utils/appUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../routes/app_pages.dart';
import '../../utils/secure_storage.dart';

class OtpController extends GetxController {
  ApiClient apiClient = ApiClient();
  var otpCode = "".obs;
  var mobileNumber = "".obs;
  TextEditingController otpController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = "".obs;
  var countryCode = "".obs;

  @override
  void onInit() {
    otpCode.value = Get.arguments["otp"];
    mobileNumber.value = Get.arguments["mobileNumber"];
    print("MobileNumbr====>${mobileNumber}");
    otpController.text = otpCode.value;
    countryCode.value = Get.arguments["countryCode"];
    // TODO: implement onInit

    super.onInit();
  }

  void updateOtp(String value) {
    otpCode.value = value; // Update the OTP value
    isError.value = false;
  }

  void verifyOtp() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
    }
    if (otpController.text.isEmpty || otpController.text.length != 6) {
      AppUtils.showSnackbarError(title: "Invalid",
          message: "Please enter 6 digit otp",
          icon: Icon(Icons.phone_rounded, color: Colors.white));
      return;
    }
    isLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      isLoading.value = true;
      isError.value = false;
      Map<String, dynamic> body = {
        "otp": otpCode.value,
        "mobilenumber": mobileNumber.value};
      Response response = await apiClient.postData(
          ApiEndPoints.VERIFY_OTP, body, handleError: false);
      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUtils.showSnackbarSuccess(title: "Success",
            message: response.body["message"] ?? "OTP sent successfully!",
            icon: Icon(Icons.password_rounded, color: Colors.white));

        print("SHUBHAMTOKEN===user/otp="+response.body["token"]);



        await SecureStorage().writeSecureData("token", response.body["token"]);
        await SecureStorage().writeSecureData("userId", response.body["userId"].toString());
        int isLogin = response.body["islogin"];
        if (isLogin == 0) {
          Get.toNamed(Routes.TERMCONDITION,arguments: {
            "mobile":mobileNumber.value,
            "countryCode":countryCode.value,
            "type": "phone"
          });
        } else {
          Get.toNamed(Routes.CATEGORY);
        }
      } else if (response.statusCode == 400) {
        otpController.clear();
        isError.value = true;
        errorMessage.value = response.body["message"];
      } else if (response.statusCode == 404) {
        AppUtils.showSnackbarError(title: "Something went wrong",
            message: response.body["message"] ?? "Please try again later");
      }
      else {
        otpController.clear();
        errorMessage.value = response.body["error"] ?? "Invalid Mobile Number";
        isError.value = true;
        throw Exception("On Else When try to login Status code: ${response
            .statusCode}\nBody: ${response.body}");
      }
    } catch (e) {
      AppUtils.showSnackbarError(
          title: "Something went wrong", message: "Please try again later");

      otpController.clear();
      isLoading.value = false;
      isError.value = false;
      throw Exception("On Catch When try to login $e");
    }
  }
  void resendOtp() async {
    isLoading.value = true;
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    try{
      isLoading.value = true;
      isError.value = false;
      Map<String,dynamic> body = {"mobilenumber":mobileNumber,
        "countrycode":countryCode};
      Response response = await apiClient.postData(ApiEndPoints.LOGIN, body,handleError: false);
      isLoading.value = false;
      otpController.clear();
      if(response.statusCode==200 || response.statusCode==201){
        AppUtils.showSnackbarSuccess(title: "Success",message: response.body["message"]??"OTP sent successfully!",icon: Icon(Icons.password_rounded,color: Colors.white));
        otpController.text = response.body["otp"];

      }else if(response.statusCode==400 || response.statusCode == 401|| response.statusCode == 404 || response.statusCode == 409){

        isError.value = true;
        errorMessage.value = response.body["message"];
        AppUtils.showSnackbarError(title: "Something went wrong",message: response.body["message"]?? "Please try again later");

      }
      else{

        errorMessage.value = response.body["error"]??"Invalid otp";
        isError.value = true;
        throw Exception("On Else When try to login Status code: ${response.statusCode}\nBody: ${response.body}");
      }
    }catch(e){
      AppUtils.showSnackbarError(title: "Something went wrong",message:"Please try again later");


      isLoading.value = false;
      isError.value = false;
      throw Exception("On Catch When try to login $e");
    }
  }

}