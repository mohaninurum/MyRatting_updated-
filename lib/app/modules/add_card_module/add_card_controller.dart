import 'package:card/app/api_manager/api_client.dart';
import 'package:card/app/response_model/category_response.dart';
import 'package:card/app/response_model/country_response/country_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/subCategory_response.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class AddCardController extends GetxController {
  ApiClient apiClient = ApiClient();
  TextEditingController titleController = TextEditingController();
  TextEditingController decsController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  RxList<XFile> pickedImages = <XFile>[].obs;

  Rx<CategoryData?> selectedCategory = Rx<CategoryData?>(null);
  Rx<SubCategoryData?> selectedSubcategory = Rx<SubCategoryData?>(null);
  RxList<CountryData> allCountries = <CountryData>[].obs;
  RxList<CountryData> selectedCountries = <CountryData>[].obs;
  RxList<CategoryData> categoryList = <CategoryData>[].obs;
  RxList<SubCategoryData> subCategoryList = <SubCategoryData>[].obs;
  RxBool isCountry = false.obs;

  RxBool isCategoryLoading = false.obs;
  RxBool isSubCategoryLoading = false.obs;
  RxBool isCardLoading = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCategory();
    getCountry();
  }

  void selectMultipleImages() async {
    List<XFile>? files = await AppUtils().pickMultipleImages();
    if (files != null && files.isNotEmpty) {
      pickedImages.addAll(files);
      update();
    }
  }

  Future<void> getCategory() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isCategoryLoading.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");

    try {
      isCategoryLoading.value = true;
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json'
      };

      Response response = await apiClient.getData(ApiEndPoints.CATEGORY,
          headers: header, handleError: false);
      isCategoryLoading.value = false;

      if (response.statusCode == 200) {
        final categoryResponse = CategoryResponse.fromJson(response.body);
        final fetchedData = categoryResponse.data ?? [];

        categoryList.assignAll(fetchedData);

        if (fetchedData.isNotEmpty) {
          selectedCategory.value = fetchedData[0];
          await getSubCategory(fetchedData[0].category_id_PK ?? 0);
        }

        print("Category List Updated: ${categoryList.length}");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isCategoryLoading.value = false;
      print("Error fetching categories: $e");
    }
  }

  Future<void> getSubCategory(int categoryId) async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isSubCategoryLoading.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");

    try {
      isSubCategoryLoading.value = true;

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json'
      };

      final url = "${ApiEndPoints.SUBCATEGORY}/$categoryId";

      Response response =
          await apiClient.getData(url, headers: header, handleError: false);
      isSubCategoryLoading.value = false;

      if (response.statusCode == 200) {
        final subCategoryResponse = SubCategoryResponse.fromJson(response.body);
        final fetchedData = subCategoryResponse.data ?? [];

        subCategoryList.assignAll(fetchedData);

        if (fetchedData.isNotEmpty) {
          selectedSubcategory.value = fetchedData[0];
        }

        print("Subcategory List Updated: ${subCategoryList.length}");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isSubCategoryLoading.value = false;
      print("Error fetching subcategories: $e");
    }
  }

  Future<void> getCountry() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isCountry.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");

    try {
      isCountry.value = true;
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json'
      };

      Response response = await apiClient.getData(ApiEndPoints.COUNTRY,
          headers: header, handleError: false);
      isCountry.value = false;

      if (response.statusCode == 200) {
        final countryResponse = CountyListResponse.fromJson(response.body);
        final fetchedData = countryResponse.data ?? [];

        allCountries.assignAll(fetchedData); // Save all for picker
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isCountry.value = false;
      print("Error fetching countries: $e");
    }
  }

  void addCard() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isCardLoading.value = false;
      return;
    }
    if (!isValidate()) {
      return;
    }
    if (pickedImages.length < 3) {
      AppUtils.showSnackbarError(
        title: "No Image Selected",
        message: "Please select at least Three image.",
      );
      return;
    }
    String authToken = await SecureStorage().readSecureData("token");
    String userId = await SecureStorage().readSecureData("userId");
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      isCardLoading.value = true;
      isError.value = false;

      List<MultipartBody> multipartBody = [];

      if (pickedImages.isNotEmpty) {
        for (int i = 0; i < pickedImages.length; i++) {
          multipartBody.add(
            MultipartBody(
              key: "images",
              file: pickedImages[i],
            ),
          );
        }
      }

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
      };

      Map<String, dynamic> body = {
        "user_id_FK": userId,
        "category_id_FK": selectedCategory.value?.category_id_PK?.toString() ?? '',
        "subcategory_id_FK":
            selectedSubcategory.value?.subcategory_id_PK?.toString() ?? '',
        "description": decsController.text,
        "title": titleController.text,
        "country_id_FK": selectedCountries.map((c) => c.country_name).toList().toString(),
      };

      Response response = await apiClient.postMultipartData(
        ApiEndPoints.ADDCARD,
        body,
        multipartBody,
        headers: header,
        handleError: false,
      );

      isCardLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearForm();
        AppUtils.showSnackbarSuccess(
          title: "Success",
          message: response.body["message"] ?? "Card added successfully!",
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else if (response.statusCode == 400) {
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
        isError.value = true;
        errorMessage.value = response.body["error"] ?? "An error occurred.";
      }
    } catch (e) {
      isCardLoading.value = false;
      isError.value = true;
      errorMessage.value = "Exception occurred. Try again later.";
      print("AddCard error: $e");
    }
  }

  void clearForm() {
    titleController.clear();
    decsController.clear();
    phoneController.clear();
    pickedImages.clear();

    selectedCategory.value = null;
    selectedSubcategory.value = null;
    subCategoryList.clear();

    selectedCountries.clear();
  }

  bool isValidate() {
    if (titleController.text.isEmpty) {
      AppUtils.showSnackbarError(
        title: "Required",
        message: "Please enter a title",
      );
      return false;
    } else if (selectedCountries.isEmpty) {
      AppUtils.showSnackbarError(
        title: "Required",
        message: "Please select at least one country",
      );
      return false;
    } else if (decsController.text.isEmpty) {
      AppUtils.showSnackbarError(
        title: "Required",
        message: "Please enter a description",
      );
      return false;
    }
    return true;
  }
}
