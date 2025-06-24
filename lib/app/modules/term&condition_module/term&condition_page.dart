import 'package:card/app/routes/app_pages.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'term&condition_controller.dart';

class TermConditionPage extends StatelessWidget {
  final TermConditionController controller = Get.put(TermConditionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Updated Terms",
                  style: AppFonts.rubik.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(controller.content.toString() ?? "",
                style: AppFonts.rubik.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
              Text(
                "Terms and conditions (T&C) are legally binding agreements that outline the rights and responsibilities"
                    " of a service provider and its users. They are also known as Terms of Service, Terms of Use, or End User License Agreement (EULA).",
                style: AppFonts.rubik.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
              Spacer(),

              // Checkbox section
              Obx(() => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: controller.isChecked.value,
                    activeColor: AppColors.primaryColor,
                    onChanged: controller.toggleCheckbox,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'I have read and agree to the Terms and Conditions.',
                        style: AppFonts.rubik.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              )),


              Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isChecked.value
                      ? AppColors.primaryColor
                      : Colors.grey,
                  minimumSize: Size(270, 50),
                ),
                onPressed: controller.isChecked.value
                    ? controller.proceedIfAgreed
                    : null,
                child: Text(
                  "I Agree",
                  style: AppFonts.IBMPlexSans.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              )),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
