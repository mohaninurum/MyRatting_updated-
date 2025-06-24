import 'package:card/app/api_manager/api_client.dart';
import 'package:card/app/response_model/category_response.dart';
import 'package:card/app/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/subCategory_response.dart';
import '../../utils/appUtils.dart';

class CategoryController extends GetxController {
  ApiClient apiClient = ApiClient();
  RxBool isCategoryLoading = false.obs;
  RxBool isSubCategoryLoading = false.obs;
  var currentViewedCategoryId = RxnInt();
  ScrollController reorderableScrollController = ScrollController();

  RxList<CategoryData> categoryList = <CategoryData>[].obs;
  RxList<SubCategoryData> subCategoryList = <SubCategoryData>[].obs;
  RxMap<int, List<String>> selectedCategorySubcategoryMap = <int, List<String>>{}.obs;
  RxMap<int, List<SubCategoryData>> categoryWiseSubcategories =
      <int, List<SubCategoryData>>{}.obs;

  var selectedCategories = <int>[].obs;
  var selectedSubcategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    restoreSelections();
  }

  // Future<void> restoreSelectionss() async {
  //   await getCategory();
  //
  //   String? filtersJson = await SecureStorage().readSecureData("filters");
  //
  //   if (filtersJson != null && filtersJson.isNotEmpty) {
  //     try {
  //       final decoded = jsonDecode(filtersJson);
  //       final List filters = decoded["filters"];
  //
  //       selectedCategories.clear();
  //       selectedCategorySubcategoryMap.clear();
  //       categoryWiseSubcategories.clear();
  //       subCategoryList.clear();
  //
  //       for (var filter in filters) {
  //         final int categoryId = filter["category_id"];
  //         final List<String> subIds = List<String>.from(filter["subcategory_ids"]);
  //
  //         if (!selectedCategories.contains(categoryId)) {
  //           selectedCategories.add(categoryId);
  //         }
  //
  //         await getSubCategory(categoryId);
  //         categoryWiseSubcategories[categoryId] = [...subCategoryList];
  //
  //
  //         selectedCategorySubcategoryMap[categoryId] = subIds;
  //       }
  //
  //
  //       if (selectedCategories.isNotEmpty) {
  //         final firstCategoryId = selectedCategories.first;
  //         currentViewedCategoryId.value = firstCategoryId;
  //         subCategoryList.assignAll(categoryWiseSubcategories[firstCategoryId] ?? []);
  //       }
  //
  //       update();
  //     } catch (e) {
  //       print("Failed to restore filters: $e");
  //     }
  //   } else {
  //     if (categoryList.isNotEmpty) {
  //       final firstCategory = categoryList.first;
  //       selectedCategories.add(firstCategory.category_id_PK!);
  //       currentViewedCategoryId.value = firstCategory.category_id_PK!;
  //       await getSubCategory(firstCategory.category_id_PK!);
  //       categoryWiseSubcategories[firstCategory.category_id_PK!] = [...subCategoryList];
  //       subCategoryList.assignAll(categoryWiseSubcategories[firstCategory.category_id_PK!] ?? []);
  //       update();
  //     }
  //   }
  // }

  Future<void> restoreSelections() async {
    await getCategory();
    for (var category in categoryList) {
      final categoryId = category.category_id_PK!;
      if (!selectedCategories.contains(categoryId)) {
        selectedCategories.add(categoryId);
      }

      await getSubCategory(categoryId);
      categoryWiseSubcategories[categoryId] = [...subCategoryList];

      final allSubIds =
          subCategoryList.map((e) => e.subcategory_id_PK.toString()).toList();
      selectedCategorySubcategoryMap[categoryId] = allSubIds;
    }

    if (selectedCategories.isNotEmpty) {
      final firstCategoryId = selectedCategories.first;
      currentViewedCategoryId.value = firstCategoryId;
      subCategoryList.assignAll(categoryWiseSubcategories[firstCategoryId] ?? []);
    }

    update();
  }

  void onReorder(int oldIndex, int newIndex) {
    final item = categoryList.removeAt(oldIndex);
    categoryList.insert(newIndex, item);
  }

  void toggleCategorySelection(CategoryData category) {
    final id = category.category_id_PK;
    if (selectedCategories.contains(id)) {
      selectedCategories.remove(id);
    } else {
      selectedCategories.add(id!);
    }

    currentViewedCategoryId.value = id; // Set the currently viewed category
    getSubCategory(id!); // Load subcategories for this category only
    update();
  }

  void toggleSubcategory(int categoryId, int subcategoryId) {
    final subcategoryList = selectedCategorySubcategoryMap[categoryId] ?? [];

    final subcategoryIdStr = subcategoryId.toString();

    if (subcategoryList.contains(subcategoryIdStr)) {
      subcategoryList.remove(subcategoryIdStr); // Remove it if it exists
    } else {
      subcategoryList.add(subcategoryIdStr); // Add it as a String
    }

    selectedCategorySubcategoryMap[categoryId] = [
      ...subcategoryList
    ]; // Update the map with the new list
    print("Updated category-subcategory map: $selectedCategorySubcategoryMap");
  }

  Future<void> getCategory() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) return;

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

        if (selectedCategories.isEmpty && fetchedData.isNotEmpty) {
          selectedCategories.add(fetchedData[0].category_id_PK!);
          await getSubCategory(fetchedData[0]
              .category_id_PK!); // Fetch subcategories for the first category
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isCategoryLoading.value = false;
      print("Error fetching categories: $e");
    }
  }

  Future<void> getSubCategory(int categoryId, {bool accumulate = false}) async {
    String authToken = await SecureStorage().readSecureData("token");
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) return;

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

        if (accumulate) {
          final newItems = fetchedData
              .where((newSub) => !subCategoryList.any(
                  (existing) => existing.subcategory_id_PK == newSub.subcategory_id_PK))
              .toList();
          subCategoryList.addAll(newItems);
          subCategoryList.sort(
            (a, b) {
              final nameA = a.subcategory_name?.toLowerCase() ?? "";
              final nameB = b.subcategory_name?.toLowerCase() ?? "";
              return nameA.compareTo(nameB);
            },
          );
        } else {
          subCategoryList.assignAll(fetchedData);
          subCategoryList.sort(
            (a, b) {
              final nameA = a.subcategory_name?.toLowerCase() ?? "";
              final nameB = b.subcategory_name?.toLowerCase() ?? "";
              return nameA.compareTo(nameB);
            },
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isSubCategoryLoading.value = false;
      print("Error fetching subcategories: $e");
    }
  }
}
