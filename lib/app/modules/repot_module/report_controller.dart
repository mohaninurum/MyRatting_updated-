import 'package:card/app/api_manager/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/get_report_response/get_report_response.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';

class ReportController extends GetxController{
  ApiClient apiClient =ApiClient();
  RxBool isLoading = false.obs;
  RxBool isLoader = false.obs;
  RxList<ReportData> reportList = <ReportData>[].obs;
  RxInt selectedIndex = (-1).obs; // To track selected item
  var selectedCountryCode = "+91".obs;
  var phoneNumber = "".obs;
  var country = "".obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController decsController = TextEditingController();
@override
onInit(){
  getReport();
}
  Future<void> getReport() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoader.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");

    try {
      isLoader.value = true;

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };

      Response response = await apiClient.getData(
        ApiEndPoints.GETREPORT,
        headers: header,
        handleError: false,
      );

      if (response.statusCode == 200) {
        final reportResponse = GetReportResponse.fromJson(response.body);

        print("Full report data: ${reportResponse.data}");

        // Remove filter to debug, add back if needed
        reportList.value = reportResponse.data ?? [];

        print("Report list length: ${reportList.length}");

      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      print("Error fetching report data: $e");
    } finally {
      isLoader.value = false;
      update();
    }
  }


  Future<void> getReportt() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoader.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");

    try {
      isLoader.value = true;

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };

      Response response = await apiClient.getData(
        ApiEndPoints.GETREPORT,
        headers: header,
        handleError: false,
      );

      if (response.statusCode == 200) {
        final reportResponse = GetReportResponse.fromJson(response.body);

        reportList.value = reportResponse.data
            ?.where((report) => (report.user_id_FK == 0 && report.card_id_FK == null))
            .toList() ?? [];

      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      print("Error fetching report data: $e");
    } finally {
      isLoader.value = false;
      update();
    }
  }

  void selectReport(int index) {
    selectedIndex.value = index;
  }

  void reportApi() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    String authToken = await SecureStorage().readSecureData("token");

    try{
      isLoading.value = true;
      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };
      String selectedReason = "";
      if (selectedIndex.value != -1 && selectedIndex.value < reportList.length) {
        selectedReason = reportList[selectedIndex.value].reason ?? "";
      }
      Map<String,dynamic> body = {
        "cardId" :"21",
      "reason":selectedReason};
      Response response = await apiClient.postData(ApiEndPoints.REPORT, body,
          headers: header,
          handleError: false);
      isLoading.value = false;
      if(response.statusCode==200 || response.statusCode==201){
        Get.back();
        AppUtils.showSnackbarSuccess(title: "Success",message: response.body["message"]??"Report added successfully",icon: Icon(Icons.warning,color: Colors.white));

      }else if(response.statusCode==400){
        titleController.clear();
        decsController.clear();
      }else if(response.statusCode==404){

        AppUtils.showSnackbarError(title: "Something went wrong",message: response.body["message"]?? "Please try again later");
      }
      else{
        titleController.clear();
        decsController.clear();
        throw Exception("On Else When try to login Status code: ${response.statusCode}\nBody: ${response.body}");
      }
    }catch(e){
      AppUtils.showSnackbarError(title: "Something went wrong",message:"Please try again later");

      titleController.clear();
      isLoading.value = false;
      throw Exception("On Catch When try to login $e");
    }
  }

}