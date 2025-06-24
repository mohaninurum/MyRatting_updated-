import 'dart:io';

import 'package:card/app/modules/profile_module/profile_controller.dart';
import 'package:card/app/routes/app_pages.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../commom widgets/common appbar.dart';
import '../dashboard_module/dashboard_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ProfileController>(
        builder: (controller) {
      return
        Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  CommonAppBar(rightWidget: SizedBox.shrink()),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors
                                      .primaryColor, width: 3),
                                ),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundImage: (controller.profileData
                                      ?.image != null &&
                                      controller.profileData?.image != "")
                                      ? NetworkImage(
                                      controller.fullImage.value)
                                      : const AssetImage(
                                      "assets/images/monstera-8477880_640.jpg") as ImageProvider,
                                )),

                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${controller.firstName.value ?? ""}',
                                    style: AppFonts.rubik.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                    ),
                                    onPressed: () {
                                      Get.toNamed(Routes.EDIT_PROFILE,
                                          arguments: {
                                            "fullname": controller.profileData
                                                ?.full_name ?? "",

                                            "email": controller.profileData
                                                ?.email ?? "",
                                            "phone": controller.profileData
                                                ?.mobile_number ?? "",
                                            "country": controller.country.value,
                                            "age": controller.profileData?.age
                                                .toString() ?? "",
                                            "countryCode" : controller.profileData?.country_code
                                                .toString() ?? "",
                                            "image": "${controller.apiClient
                                                .url}${controller.profileData
                                                ?.image??""}",

                                          }
                                      );

                                    },
                                    child: Text(
                                      "Edit Profile",
                                      style: AppFonts.rubik.copyWith(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           /* Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("USER INFO", style: AppFonts.rubik
                                  .copyWith(color: Colors.grey,
                                  fontWeight: FontWeight.w600)),
                            ),
                            Column(
                              children: [
                                _buildProfileTile(
                                  icon: Icons.person,
                                  title: "First Name",
                                  value: controller.profileData?.first_name ??
                                      "",
                                  color: Colors.black54,
                                ),
                                _buildProfileTile(
                                  icon: Icons.person,
                                  title: "Last Name",
                                  value: controller.profileData?.last_name ??
                                      "",
                                  color: Colors.black54,
                                ),
                                _buildProfileTile(
                                  icon: Icons.calendar_month,
                                  title: "Age",
                                  value: controller.profileData?.age
                                      .toString() ?? "",
                                  color: Colors.black54,
                                ),
                                _buildProfileTile(
                                  icon: Icons.email,
                                  title: "Email",
                                  value: controller.profileData?.email ?? "",
                                  color: Colors.black54,
                                ),
                                _buildProfileTile(
                                  icon: Icons.phone,
                                  title: "Phone",
                                  value: controller.profileData
                                      ?.mobile_number ?? "",
                                  color: Colors.black54,
                                ),
                                _buildProfileTile(
                                  icon: Icons.location_on,
                                  title: "Country",
                                  value: controller.profileData
                                      ?.country_code ?? "",
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),*/
                            Text("OPTIONS", style: AppFonts.rubik.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600)),
                            Column(
                              children: [

                                _buildOptionTile(
                                  icon: Icons.settings,
                                  title: "Select Category",
                                  color: Colors.grey,
                                  onTap: () {
                                    Get.toNamed(Routes.CATEGORY);
                                  },
                                ),
                               /* _buildOptionTile(
                                  icon: Icons.settings,
                                  title: "Settings",
                                  color: Colors.grey,
                                  onTap: () {},
                                ),*/
                                _buildOptionTile(
                                  icon: Icons.headphones,
                                  title: "Contact Us",
                                  color: Colors.grey,
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                        "https://www.google.com");
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },

                                ),
                                _buildOptionTile(
                                  icon: Icons.policy,
                                  title: "Privacy Policy ",
                                  color: Colors.grey,
                                  onTap: () {
                                    Get.toNamed(Routes.PRIVACY_POLICY);
                                  },
                                ),
                               /* _buildOptionTile(
                                  icon: Icons.flag,
                                  title: "Report",
                                  color: Colors.red,
                                  onTap: () {
                                    Get.toNamed(Routes.REPORT);
                                    // Navigate to settings
                                  },
                                ),*/
                                _buildOptionTile(
                                  icon: Icons.logout,
                                  title: "Logout",
                                  color: Colors.red,
                                  onTap: () async {
                                    bool? result = await showDialog<bool>(
                                      context: context,
                                      // Use the context from onTap directly
                                      builder: (context) {
                                        return ExitDialogScreen(
                                          isExitDialog: false, // Set this to false to indicate it's a logout dialog
                                        );
                                      },
                                    );
                                  },
                                  showDivider: false,
                                ),
                                _buildOptionTile(
                                  icon: Icons.delete,
                                  title: "Delete Account",
                                  color: Colors.red,
                                  onTap: () async {
                                    showPhoneNumberDialog(context);
                                  },
                                  showDivider: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
    }
    );
  }
  Widget buildOptionButton(ProfileController controller) {
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
            controller.selectImageFile(ImageSource.gallery); // Pick image from the gallery
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
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Image.asset(
            "assets/images/instagram.png", // Your icon here
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
  void showPhoneNumberDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter your phone number",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          content:      Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
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
                    width: 100,
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
                      hintText: 'Enter phone number',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: (){
                controller.sendOtpOnMobile(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Send OTP",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFonts.rubik.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value!,
                      style: AppFonts.rubik.copyWith(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppFonts.rubik.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
      ],
    );
  }
}
