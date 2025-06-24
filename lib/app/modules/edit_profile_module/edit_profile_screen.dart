import 'dart:io';

import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../commom widgets/primary_button.dart';
import '../../utils/strings.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          Strings.editProfile,
          style: AppFonts.rubik.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40), // Add enough bottom padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryColor, width: 3),
                      ),
                      child: Obx(() {
                        ImageProvider imageProvider;

                        if (controller.pickedImage.value != null) {
                          imageProvider =
                              FileImage(File(controller.pickedImage.value!.path));
                        } else if (controller.image.value.isNotEmpty) {
                          imageProvider = NetworkImage(controller.image.value);
                        } else {
                          imageProvider =
                              const AssetImage("assets/images/monstera-8477880_640.jpg");
                        }

                        return CircleAvatar(
                          radius: 28,
                          backgroundImage: imageProvider,
                        );
                      }),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: buildOptionButton(controller),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildDetail(controller, controller.emailController, "Email", "Email",
                    readOnly: true),
                buildDetail(
                    controller, controller.firstNameController, "Full Name", "Full Name"),
                //  buildDetail(controller, controller.lastNameController, "Last Name", "Last Name"),

                aboveField("Age"),
                buildAgePicker(context),

                buildPhoneField(controller, readOnly: true),

                SizedBox(height: 20),

                Obx(() => Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PrimaryButton(
                          textColor: AppColors.white,
                          height: 52,
                          btnColor: AppColors.primaryColor,
                          onPressed: () async {
                            await controller.editProfile();
                          },
                          isLoading: controller.isLoading.value,
                          title: "Update",
                          borderColor: AppColors.primaryColor,
                          hasIcon: false,
                        ),
                      ),
                    )),
                SizedBox(height: 30), // Ensures the button doesn't get cut off
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOptionButton(EditProfileController controller) {
    return PullDownButton(
      itemBuilder: (context) => [
        PullDownMenuItem(
          onTap: () {
            controller.selectImageFile(ImageSource.camera); // Pick image from the camera
          },
          icon: CupertinoIcons.camera,
          title: "Camera",
        ),
        PullDownMenuItem(
          onTap: () {
            controller
                .selectImageFile(ImageSource.gallery); // Pick image from the gallery
          },
          icon: CupertinoIcons.photo,
          title: "Gallery",
        ),
        PullDownMenuItem(
          onTap: () {},
          title: "Cancel",
          isDestructive: true, // Optional: this is just for style
        ),
      ],
      buttonBuilder: (context, showMenu) => CupertinoButton(
        onPressed: showMenu, // Show the menu when button is pressed
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.camera_alt_outlined, // Your icon here
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget aboveField(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Align(
        alignment: Alignment.bottomLeft, // Aligns to the right of the parent
        child: Text(
          title,
          style: AppFonts.rubik.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget buildDetail(
    EditProfileController controller,
    TextEditingController controllerName,
    String hint,
    String aboveText, {
    bool readOnly = false, // default is editable
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              aboveText,
              style: AppFonts.rubik.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            controller: controllerName,
            readOnly: readOnly, // <-- makes the field read-only when true
            decoration: InputDecoration(
              hintText: 'Enter your $hint',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhoneField(EditProfileController controller, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryColor, width: 2),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Obx(() {
              final countryCode = controller.countryCode.value;
              print("Initial Country Code: $countryCode");

              if (countryCode.isEmpty) {
                return const SizedBox();
              }

              return SizedBox(
                  width: 80,
                  child: Obx(() => IntlPhoneField(
                        key: ValueKey(controller.country.value),
                        initialCountryCode: controller.country.value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                        ),
                        onChanged: (phone) {
                          controller.phoneController.text = phone.completeNumber;
                        },
                        onCountryChanged: (country) {
                          controller.selectedCountryCode.value = "+${country.dialCode}";
                          print(
                              "Country changed to: ${country.name} (+${country.dialCode})");
                        },
                        showDropdownIcon: false,
                        enabled: false, // disables user interaction
                      )));
            }),

            Container(
              height: 30,
              width: 1.5,
              color: Colors.grey.shade500,
            ),

            SizedBox(width: 5),

            // Phone Number Field or read-only text
            Expanded(
              child: readOnly
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        controller.phoneController.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: controller.updatePhoneNumber,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        border: InputBorder.none,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAgePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 20, right: 20),
      child: Obx(() {
        return GestureDetector(
          onTap: () async {
            final today = DateTime.now();
            final maxDate = DateTime(today.year - 13, today.month, today.day);
            final firstDate = DateTime(1900);

            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: controller.selectedBirthDate.value ?? maxDate,
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
              border: Border.all(color: AppColors.primaryColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedBirthDate.value != null
                      ? DateFormat('yyyy-MM-dd')
                          .format(controller.selectedBirthDate.value!)
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
}
