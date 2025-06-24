import 'dart:io';

import 'package:card/app/api_manager/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:pinput/pinput.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../commom widgets/delete_account.dart';
import '../../response_model/get_profile_response/get_profile_response.dart';
import '../../routes/app_pages.dart';
import '../../utils/appColors.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class ProfileController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  ApiClient apiClient = ApiClient();
  RxBool isLoading = false.obs;
  var firstName = "John".obs;
  var lastName = "Doe".obs;
  var department = "App Developer".obs;
  var email = "john.doe@example.com".obs;
  var phone = "+1234567890".obs;
  var country = "IN".obs;
  var countryCode = "".obs;

  var role = "App Developer".obs;
  var fullImage = "".obs;
  RxBool isLoader = false.obs;
  var selectedCountryCode = "+91".obs;
  var phoneNumber = "".obs;
  var fcmToken = "".obs;
  Rx<XFile?> pickedImage = Rx<XFile?>(null);
  var profileImage = Rx<File?>(null);
  ProfileData? profileData;

  void showImagePickerOptions() {}

  void logoutUser() {}

  var showLoader = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  Future<void> onInit() async {
    super.onInit();
    String? savedCountryCode = await SecureStorage().readSecureData("country");
    countryCode.value = savedCountryCode ?? "IN";
    await getProfile();
  }

  void selectImageFile(ImageSource source) async {
    XFile? file = await AppUtils().pickImage(source);
    if (file != null) {
      pickedImage.value = file;
      //updateImage();
      update();
    }
  }

  Future<void> getProfile() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoader.value = false;
      return;
    }
    String authToken = await SecureStorage().readSecureData("token");
    String userId = await SecureStorage().readSecureData("userId");

    try {
      isLoader.value = true;

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };

      final url = "${ApiEndPoints.USERPROFILE}/$userId";

      Response response = await apiClient.getData(
        url,
        headers: header,
        handleError: false,
      );

      isLoader.value = false;
      update();
      if (response.statusCode == 200) {
        final profileResponse = GetProfileResponse.fromJson(response.body);
        profileData = profileResponse.data;

        if (profileData?.image != null || profileData?.image != "") {
          print("ProfileData ===> $profileData");
          fullImage.value = "${apiClient.url}${profileData!.image}";
          firstName.value = profileData?.full_name.toString() ?? "";
          print("FullName====>${firstName.value}");
          // lastName.value = profileData?.last_name.toString() ?? "";
          print("Profile Image URL: $fullImage");
        }
        update();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
        update();
      }
    } catch (e) {
      isLoader.value = false;
      print("Error fetching profile data: $e");
      update();
    }
  }

  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
  }

  bool isPhoneNumberValid() {
    try {
      final fullNumber = '${selectedCountryCode.value}${phoneNumber.value}';
      print("FullNumber=====>${fullNumber}");
      final parsed = PhoneNumber.parse(fullNumber);
      return parsed.isValid();
    } catch (_) {
      return false;
    }
  }

  void sendOtpOnMobile(BuildContext context) async {
    isLoading.value = true;
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
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
      Map<String, dynamic> body = {
        "mobilenumber": phoneController.text,
        "countrycode": selectedCountryCode.value
      };

      Response response =
          await apiClient.postData(ApiEndPoints.LOGIN, body, handleError: false);
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUtils.showSnackbarSuccess(
          title: "Success",
          message: response.body["message"] ?? "OTP sent successfully!",
          icon: Icon(Icons.password_rounded, color: Colors.white),
        );
        Navigator.of(context).pop();
        _showOtpDialog(context, response.body["otp"]);
        print("SHUBHAMTOKEN===user/profile=" + response.body["token"]);

        await SecureStorage().writeSecureData("token", response.body["token"]);

        print("FcmToken===>${fcmToken}");
      } else if ([400, 401, 404, 409].contains(response.statusCode)) {
        phoneController.clear();
        AppUtils.showSnackbarError(
          title: "Something went wrong",
          message: response.body["message"] ?? "Please try again later",
        );
      } else {
        phoneController.clear();
        throw Exception("Status code: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      AppUtils.showSnackbarError(
        title: "Something went wrong",
        message: "Please try again later",
      );
      phoneController.clear();
      isLoading.value = false;
      throw Exception("Send OTP Error: $e");
    }
  }

  void _showOtpDialog(BuildContext context, String correctOtp) {
    final TextEditingController otpController =
        TextEditingController(text: correctOtp); // Pre-fill OTP
    print("corectOtp===>${correctOtp}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter OTP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("We sent an OTP to your mobile number."),
              SizedBox(height: 20),
              Center(
                child: Pinput(
                  onChanged: (value) {},
                  closeKeyboardWhenCompleted: true,
                  controller: otpController,
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 50,
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primaryColor, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () async {
                String enteredOtp = otpController.text.trim();

                if (enteredOtp == correctOtp) {
                  AppUtils.showSnackbarSuccess(
                    title: "Success",
                    message: "OTP Verified!",
                    icon: Icon(Icons.check_circle, color: Colors.white),
                  );
                  verifyOtp(context, enteredOtp, context);
                } else {
                  AppUtils.showSnackbarError(
                    title: "Invalid OTP",
                    message: "Please enter the correct OTP.",
                    icon: Icon(Icons.error, color: Colors.white),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Verify OTP",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close OTP dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void verifyOtp(BuildContext context, String otp, BuildContext dialogContext) async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
    }

    if (otp.isEmpty || otp.length != 6) {
      AppUtils.showSnackbarError(
        title: "Invalid",
        message: "Please enter a 6-digit OTP",
        icon: Icon(Icons.phone_rounded, color: Colors.white),
      );
      return;
    }

    isLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      Map<String, dynamic> body = {
        "otp": otp,
        "mobilenumber": phoneController.text,
        "countrycode": selectedCountryCode.value,
      };
      Response response =
          await apiClient.postData(ApiEndPoints.VERIFY_OTP, body, handleError: false);
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        int isLogin = response.body["islogin"];
        if (isLogin == 1) {
          Navigator.of(dialogContext).pop();
          showDeleteAccountDialog(context);
        } else {
          AppUtils.showSnackbarError(
            title: "User Not Exist",
            message: "Please enter correct number",
          );
        }
      } else if (response.statusCode == 400) {
      } else if (response.statusCode == 404) {
        AppUtils.showSnackbarError(
          title: "Something went wrong",
          message: response.body["message"] ?? "Please try again later",
        );
      } else {
        throw Exception(
            "Unexpected response: ${response.statusCode}\nBody: ${response.body}");
      }
    } catch (e) {
      AppUtils.showSnackbarError(
        title: "Something went wrong",
        message: "Please try again later",
      );
      isLoading.value = false;
      throw Exception("Error during OTP verification: $e");
    }
  }

  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteAccountDialog(
        onConfirm: () {
          deleteAccount();
        },
      ),
    );
  }

  void deleteAccount() async {
    try {
      final isConnected = await AppService.checkInternetConnectivity();
      if (!isConnected) {
        AppUtils.showSnackbarError(
          title: "No Internet",
          message: "Please check your internet connection.",
        );
        return;
      }

      final userId = await SecureStorage().readSecureData("userId");
      String authToken = await SecureStorage().readSecureData("token");

      if (userId == null || userId.isEmpty) {
        AppUtils.showSnackbarError(
          title: "Error",
          message: "User ID not found. Please login again.",
        );
        return;
      }

      String url = "${ApiEndPoints.DELETEACCOUNT}/$userId";
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };
      Response response = await apiClient.deleteData(
        url,
        headers: header,
        handleError: true,
      );

      if (response.statusCode == 200) {
        AppUtils.showSnackbarSuccess(
          title: "Deleted",
          message: "Your account has been deleted successfully.",
        );
        await SecureStorage().deleteAllData();
        Get.offAllNamed(Routes.CREATE_ACOOUNT);
      } else {
        AppUtils.showSnackbarError(
          title: "Failed",
          message: response.body["message"] ?? "Failed to delete account.",
        );
      }
    } catch (e) {
      AppUtils.showSnackbarError(
        title: "Error",
        message: "Something went wrong, please try again later.",
      );
      print("Delete Account Error: $e");
    }
  }
}
