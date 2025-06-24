import 'package:card/app/api_manager/api_client.dart';
import 'package:get/get.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/category_response.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';


class ExploreCategoryController extends GetxController {
  RxBool  isCategoryLoading = false.obs;
  RxBool isSubCategoryLoading = false.obs;

  RxList<CategoryData> categoryList = <CategoryData>[].obs;

  var selectedCategory = Rxn<CategoryData>();
  var selectedSubcategories = <String>[].obs;

  ApiClient apiClient = ApiClient();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCategory();
  }
  /*var categories = [
    {"category": "Beverages", "image": 'assets/images/refreshment-9368874_640.jpg'},
    {"category": "Snacks", "image": 'assets/images/rapeseed-7102819_640.jpg'},
    {"category": "Food", "image": 'assets/images/rapeseed-7102819_640.jpg'},
  ];


  List<Map<String, dynamic>> get allCategories => categories;
*/
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

      Response response = await apiClient.getData(ApiEndPoints.CATEGORY, headers: header, handleError: false);
      isCategoryLoading.value = false;

      if (response.statusCode == 200) {
        final categoryResponse = CategoryResponse.fromJson(response.body);
        final fetchedData = categoryResponse.data ?? [];

        categoryList.assignAll(fetchedData);

    update();

        print("Category List Updated: ${categoryList.length}");
      }
      else if(response.statusCode==401 || response.statusCode==403){

        AppUtils.appService.userSessionExpire();
        print("Token Expired");
      }
    } catch (e) {
      isCategoryLoading.value = false;
      print("Error fetching categories: $e");
    }
  }

}
