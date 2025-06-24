import 'dart:io';

import 'package:card/app/api_manager/api_client.dart';
import 'package:card/app/modules/profile_module/profile_controller.dart';
import 'package:card/app/utils/appUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../utils/secure_storage.dart';

class EditProfileController extends GetxController {
  ApiClient apiClient = ApiClient();
  var email = "".obs;
  var firstname = "".obs;
  var lastName = "".obs;
  var country = "".obs;
  var phone = "".obs;
  var image = "".obs;
  var countryCode = "".obs;
  Rx<XFile?> pickedImage = Rx<XFile?>(null);
  var phoneNumber = "".obs;
  var selectedCountryCode = "+91".obs;
  var age = "".obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = "".obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  var selectedBirthDate = Rxn<DateTime>(); // Nullable reactive date
  var selectedAge = 0.obs;
  List<String> ageOptions = List.generate(88, (index) => (index + 13).toString());

  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
  }

  void selectImageFile(ImageSource source) async {
    XFile? file = await AppUtils().pickImage(source);
    if (file != null) {
      pickedImage.value = file;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments["email"];
    firstname.value = Get.arguments["fullname"];
    // lastName.value = Get.arguments["lastName"];
    country.value = Get.arguments["country"];
    phone.value = Get.arguments["phone"];
    final argAge = Get.arguments["age"];
    age.value = (argAge == null || argAge == "null") ? "Select Date of Birth" : argAge;

    if (argAge != null && argAge != "null") {
      try {
        selectedBirthDate.value = DateTime.parse(argAge).toLocal();
      } catch (e) {
        print("Error parsing age date: $e");
      }
    }
    image.value = Get.arguments["image"];
    countryCode.value = Get.arguments["countryCode"] ?? "IN";
    emailController.text = email.value;
    firstNameController.text = firstname.value;
    lastNameController.text = lastName.value;
    phoneController.text = phone.value;
  }

  Future<void> editProfile() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
    }
    String authToken = await SecureStorage().readSecureData("token");
    String userId = await SecureStorage().readSecureData("userId");

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      isLoading.value = true;
      isError.value = false;
      List<MultipartBody> multipartBody = [];

      if (pickedImage.value != null) {
        XFile xFile = XFile(pickedImage.value!.path); // Convert File to XFile
        multipartBody.add(
          MultipartBody(
            key: "image",
            file: xFile, // Pass the XFile
          ),
        );
      } else if (image.value.isNotEmpty) {
        try {
          final response = await http.get(Uri.parse(image.value));
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/profile.jpg');
          await file.writeAsBytes(response.bodyBytes);

          XFile xFile = XFile(file.path);
          multipartBody.add(
            MultipartBody(
              key: "image",
              file: xFile, // Pass the XFile
            ),
          );
        } catch (e) {
          print("Error downloading image: $e");
        }
      }
      final url = "${ApiEndPoints.EDITPROFILE}/$userId";
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "multipart/form-data",
      };

      Map<String, dynamic> body = {
        "fullname": firstNameController.text,
        // "lastname": lastNameController.text,
        "age": DateFormat('yyyy-MM-dd').format(selectedBirthDate.value!),
      };

      Response response = await apiClient.postMultipartData(
        url,
        body,
        multipartBody,
        headers: header,
        handleError: false,
      );

      isLoading.value = false;
      if (response.statusCode == 200) {
        Get.back();
        AppUtils.showSnackbarSuccess(
            title: "Success",
            message: response.body["message"] ?? "Profile updated successfully",
            icon: Icon(Icons.password_rounded, color: Colors.white));
        ProfileController profileController = Get.find<ProfileController>();
        profileController.getProfile();
        profileController.update();
      } else if (response.statusCode == 400) {
        AppUtils.showSnackbarError(
            title: "Something went wrong",
            message: response.body["message"] ?? "Please try again later");
        isError.value = true;
        errorMessage.value = response.body["error"];
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      } else if (response.statusCode == 404 ||
          response.statusCode == 409 ||
          response.statusCode == 500) {
        AppUtils.showSnackbarError(
            title: "Something went wrong",
            message: response.body["message"] ?? "Please try again later");
      } else {
        clearFields();
        errorMessage.value = response.body["error"] ?? "Invalid Mobile Number";
        isError.value = true;
        throw Exception(
            "On Else When try to login Status code: ${response.statusCode}\nBody: ${response.body}");
      }
    } catch (e) {
      AppUtils.showSnackbarError(
          title: "Something went wrong", message: "Please try again later");

      clearFields();
      isLoading.value = false;
      isError.value = false;
      throw Exception("On Catch When try to login $e");
    }
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    pickedImage.value = null;
  }
}
