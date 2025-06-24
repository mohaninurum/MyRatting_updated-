import 'package:card/app/commom%20widgets/signin%20button.dart';
import 'package:card/app/modules/create_account_module/create_acoount_controller.dart';
import 'package:card/app/routes/app_pages.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:card/app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});
  final CreateAccountController controller = Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigth = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final padding = MediaQuery.of(context).padding;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final devicePixcelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
        body: Container(
      color: AppColors.secondaryColor,
      height: screenHeigth,
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 35,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "My Rating App",
                style: AppFonts.IBMPlexSans.copyWith(
                    fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.white),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  Strings.bytapping,
                  style: AppFonts.rubik.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13),
                ),
              ),
              SignInCommonButton(
                text: "Sign in with Google",
                textStyle: AppFonts.IBMPlexSans.copyWith(fontWeight: FontWeight.w600),
                onPressed: () async {
                  await controller.handleSignIn();
                },
                backgroundColor: AppColors.white,
                borderRadius: 25,
                prefixIcon: Row(
                  children: [
                    Image.asset(
                      "assets/images/search.png",
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SignInCommonButton(
                text: "Continue with phone number",
                textStyle: AppFonts.IBMPlexSans.copyWith(fontWeight: FontWeight.w600),
                onPressed: () {
                  Get.toNamed(Routes.LOGIN);
                },
                backgroundColor: AppColors.white,
                borderRadius: 25,
                prefixIcon: Image.asset(
                  "assets/images/call.png",
                  height: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Trouble signing in?",
                style: AppFonts.rubik.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
