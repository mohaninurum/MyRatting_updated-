import 'package:card/app/modules/splash_module/splash_controller.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});
  final SplashController controller = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppColors.secondaryColor,
      child: Center(
          child: Image.asset(
        "assets/images/logo.png",
        height: 100,
        color: Colors.white,
      )),
    ));
  }
}
