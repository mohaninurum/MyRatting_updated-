import 'package:card/app/modules/submit_detail_module/submit_detail_controller.dart';
import 'package:card/app/routes/app_pages.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:card/app/utils/strings.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../commom widgets/primary_button.dart';

class SubmitDetailPage extends GetView<SubmitDetailController> {
  const SubmitDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            Strings.fillDetail,
            style: AppFonts.rubik.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primaryColor,
            ),
          ),
          centerTitle: true,
          leading: SizedBox.shrink(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Full Name"),
                _buildTextField(controller.firstNameController, "Enter Full name"),

                /*_buildLabel("Last Name"),
                _buildTextField(controller.lasttNameController, "Enter Last name"),
*/
                _buildLabel("Phone Number"),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Country Picker Code
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              controller.selectedCountryCode.value = "+${country.phoneCode}";
                              controller.country.value = country.countryCode;
                            },
                          );
                        },
                        child:  Row(
                          children: [
                            Obx(() => Text(
                              controller.selectedCountryCode.value,
                              style: const TextStyle(fontSize: 16),
                            )),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        height: 24,
                        width: 1.5,
                        color: Colors.grey.shade400,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),

                      // Phone Number Field
                      Expanded(
                        child: Obx(() => TextField(
                          enabled: controller.isPhoneEditable.value,
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: controller.updatePhoneNumber,
                          decoration: const InputDecoration(
                            hintText: 'Enter phone number',
                            border: InputBorder.none,
                            counterText: "",
                          ),
                        )),
                      ),
                    ],
                  ),
                ),


                _buildLabel("Age"),
                buildAgePicker(context),
              //  _buildAgeDropdown(),

                _buildLabel("Email"),
                _buildTextField(controller.emailController, "Enter email",enabled: controller.isEmailEditable.value,),

                const SizedBox(height: 20),
                Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: PrimaryButton(
                    textColor: AppColors.white,
                    height: 52,
                    btnColor: AppColors.primaryColor,
                    onPressed: () {
                      controller.register();
                    },
                    isLoading: controller.isLoading.value,
                    title:Strings.submit,
                    borderColor: AppColors.primaryColor,
                    hasIcon: false,
                  ),
                )),

              ],
            ),
          ),
        ));
  }

  Widget _buildLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 8),
      child: Text(
        title,
        style: AppFonts.rubik.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint, {
        bool isNumber = false,
        int? maxLength,
        bool enabled = true,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          counterText: "",
          hintStyle: AppFonts.rubik.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: _outlineBorder(),
          enabledBorder: _outlineBorder(),
          focusedBorder: _outlineBorder(color: Colors.blue),
          disabledBorder: _outlineBorder(color: Colors.grey.shade400), // optional style
          errorBorder: _outlineBorder(color: Colors.red),
          focusedErrorBorder: _outlineBorder(color: Colors.red),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineBorder({Color color = Colors.grey}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
  Widget buildAgePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Obx(() {
        return GestureDetector(
          onTap: () async {
            final today = DateTime.now();
            final maxDate = DateTime(today.year - 13, today.month, today.day); // Must be at least 13
            final firstDate = DateTime(1900); // Earliest date selectable

            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: maxDate,
              firstDate: firstDate,
              lastDate: maxDate,
            );

            if (picked != null) {
              controller.selectedBirthDate.value = picked;

              controller.selectedAge.value = today.year - picked.year;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedBirthDate.value != null
                      ? DateFormat.yMMMd().format(controller.selectedBirthDate.value!)
                      : "Select Date of Birth",
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAgeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Obx(() {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1.5),
          ),
          child: DropdownButton<int>(
            isExpanded: true,
            underline: SizedBox(),
            value: controller.selectedAge.value,
            icon: Icon(Icons.arrow_drop_down),
            items: controller.ageList
                .map((age) => DropdownMenuItem<int>(
              value: age,
              child: Text(age.toString()),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) controller.selectedAge.value = value;
            },
          ),
        );
      }),
    );
  }
}
