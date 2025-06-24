import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../app_service/app_service.dart';
import 'appColors.dart';

class AppUtils{
  static AppService appService = Get.find<AppService>();

  final ImagePicker picker = ImagePicker();
  Future<XFile?> pickImage(ImageSource source) async {
    try{
      var pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        return pickedFile;
      }
    }catch(e){
      print("ERROR:: ${e}");
    }
    return null;

  }
  Future<List<XFile>?> pickMultipleImages() async {
    try {
      final List<XFile>? pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        return pickedFiles;
      }
    } catch (e) {
      print("Multiple image pick error: $e");
    }
    return null;
  }

  static void showSnackbarSuccess({required String title, required String message, Icon? icon,int? seconds}) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      icon: icon??Icon(Icons.done_all,color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration:  Duration(seconds: seconds??2),
      isDismissible: false,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showSnackbarError({required String title, required String message, Widget? icon,int? duration,Color? backgroundColor }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      title,
      message,
      icon: icon??const SizedBox(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration:  Duration(seconds: duration??2),
      isDismissible: false,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }


}

