import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      // Get.find<AuthController>().clearSharedData();
      // Get.offAllNamed(RouteHelper.getSignInRoute());
    }else if(response.statusCode==400){
      // showCustomSnackBar(response.statusText);
    }
  }
}