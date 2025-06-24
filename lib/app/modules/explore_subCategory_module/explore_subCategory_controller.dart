import 'package:card/app/api_manager/api_client.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/subCategory_response.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class ExploreSubCategoryController extends GetxController{
  ApiClient apiClient = ApiClient();
  RxBool isSubCategoryLoading = false.obs;

  RxList<SubCategoryData> subCategoryList = <SubCategoryData>[].obs;


  var categoryId = "".obs;


 // List<Map<String, dynamic>> get allCategories => categories;
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSubCategory();
    categoryId.value = Get.arguments["categoryId"];
  }
  Future<void> getSubCategory() async {
    String authToken = await SecureStorage().readSecureData("token");
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isSubCategoryLoading.value = false;
      return;
    }
    try {
      isSubCategoryLoading.value = true;

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json'
      };

      final url = "${ApiEndPoints.SUBCATEGORY}/$categoryId";

      Response response = await apiClient.getData(url, headers: header, handleError: false);
      isSubCategoryLoading.value = false;

      if (response.statusCode == 200) {
        final subCategoryResponse = SubCategoryResponse.fromJson(response.body);
        final fetchedData = subCategoryResponse.data ?? [];

        subCategoryList.assignAll(fetchedData);
        update();
        /*if (fetchedData.isNotEmpty) {
          selectedSubcategories.clear(); // Optional: if you want to clear previous
          selectedSubcategories.add(fetchedData.first.subcategory_name ?? "");
        }*/

        print("Subcategory List Updated: ${subCategoryList.length}");
      }else if(response.statusCode==401 || response.statusCode==403){

        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      isSubCategoryLoading.value = false;
      print("Error fetching subcategories: $e");
    }
  }

}