import 'package:card/app/modules/login_module/login_controller.dart';
import 'package:card/app/routes/app_pages.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:card/app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../commom widgets/primary_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

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
          children: [
            Text(
              Strings.getwegtNm,
              style: AppFonts.rubik.copyWith(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                children: [
                  Obx(() {
                    final countryCode = controller.country.value;
                    print("Initial Country Code: $countryCode");

                    if (countryCode.isEmpty) {
                      return const SizedBox();
                    }

                    return SizedBox(
                      width: 120,
                      child: IntlPhoneField(
                        key: ValueKey(countryCode),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                        ),
                        initialCountryCode: countryCode,
                        onChanged: (phone) {
                          controller.phoneController.text = phone.completeNumber;
                        },
                        onCountryChanged: (country) {
                          controller.selectedCountryCode.value = "+${country.dialCode}";
                          print("Country changed to: ${country.name} (+${country.dialCode})");
                        },
                        readOnly: true,
                      ),
                    );
                  }),


                  Container(height: 20, width: 2, color: Colors.grey.shade600),
                SizedBox(width: 5,),
                  Expanded(
                    child: TextField(
                      maxLength: null,
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: controller.updatePhoneNumber,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your phone number',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Text(
              Strings.wetxtyoua,
              style: AppFonts.rubik.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            SizedBox(height: 30),

            Obx(() => PrimaryButton(
              textColor: AppColors.white,
              height: 52,
              btnColor: AppColors.primaryColor,
              onPressed: () {
                print("Phone Number: ${controller.phoneController.text}");
                controller.sendOtpOnMobile();
              },
              isLoading: controller.isLoading.value,
              title: "Next",
              borderColor: AppColors.primaryColor,
              hasIcon: false,
            )),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}



