import 'package:card/app/modules/otp_module/otp_controller.dart';
import 'package:card/app/routes/app_pages.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:card/app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../commom widgets/primary_button.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});
  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade700,
            size: 30,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.entrcode,
              style: AppFonts.rubik.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            SizedBox(height: 8),
            Text(
              controller.mobileNumber.value,
              style: AppFonts.rubik.copyWith(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Pinput(
                onChanged: (value) => controller.updateOtp(value),
                closeKeyboardWhenCompleted: true,
                controller: controller.otpController,
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 50,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color:  AppColors.primaryColor, width: 2
                     // bottom: BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.tryAgain,
                  style: AppFonts.rubik.copyWith(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    controller.resendOtp();
                  },
                  child: Text(
                    Strings.resend,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: PrimaryButton(
                textColor: AppColors.white,
                height: 52,
                btnColor: AppColors.primaryColor,
                onPressed: controller.otpCode.value.length == 6
                    ? () {
                  controller.verifyOtp();
                }
                    : null, // Correct way: assign null or a function
                isLoading: controller.isLoading.value,
                title: "Next",
                borderColor: AppColors.primaryColor,
                hasIcon: false,
              ),
            )),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
