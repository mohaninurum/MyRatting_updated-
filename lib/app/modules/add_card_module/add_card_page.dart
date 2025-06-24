import 'dart:io';

import 'package:card/app/modules/add_card_module/add_card_controller.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commom widgets/primary_button.dart';
import '../../response_model/category_response.dart';
import '../../response_model/country_response/country_response.dart';
import '../../response_model/subCategory_response.dart';
import '../../utils/appFonts.dart';
class AddCardPage extends StatelessWidget {
  AddCardPage({super.key});
  final AddCardController controller = Get.put(AddCardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          Strings.addCard,
          style: AppFonts.rubik.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
          leading: SizedBox.shrink()
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetail(controller, controller.titleController, Strings.pleaseEnterTitle, 1, Strings.title),
           // buildDetail(controller, controller.suggestionController, Strings.pleaseEnterSuggestn, 1, Strings.suggestion),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Country',
                style: AppFonts.rubik.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: InkWell(
                onTap: () => showMultiCountryPicker(
                  context,
                  controller.selectedCountries,
                  controller.allCountries,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                  ),
                  child: Obx(() {
                    if (controller.selectedCountries.isEmpty) {
                      return const Text("Select Countries");
                    }

                    return Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: controller.selectedCountries.map((c) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Chip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    "${controller.apiClient.url}${c.flag}",
                                    width: 24,
                                    height: 16,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.flag_outlined, size: 16),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(c.country_name ?? ''),
                                ],
                              ),
                            ),

                            Positioned(
                              right: -20,
                              top: -17,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  controller.selectedCountries.removeWhere(
                                        (country) => country.iCountryCode == c.iCountryCode,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }),
                ),
              ),
            ),




            buildDetail(controller, controller.decsController, Strings.pleaseEnterDescptn, 4, Strings.description),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Category',
                    style: AppFonts.rubik.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(() {
                    return DropdownButtonFormField<CategoryData>(
                      value: controller.selectedCategory.value,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                        ),
                      ),
                      hint: Text(controller.categoryList.isEmpty ? 'Category not found' : 'Select a category'),
                      onChanged: controller.categoryList.isEmpty
                          ? null
                          : (CategoryData? newValue) async {
                        controller.selectedCategory.value = newValue!;
                        await controller.getSubCategory(newValue.category_id_PK ?? 0);
                        controller.selectedSubcategory.value = controller.subCategoryList.isNotEmpty
                            ? controller.subCategoryList.first
                            : null;
                      },
                      items: controller.categoryList.isNotEmpty
                          ? controller.categoryList
                          .map((category) => DropdownMenuItem<CategoryData>(
                        value: category,
                        child: Text(category.category_name ?? ''),
                      ))
                          .toList()
                          : [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Category not found'),
                        )
                      ],
                    );
                  }),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Subcategory',
                    style: AppFonts.rubik.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(() {
                    return DropdownButtonFormField<SubCategoryData>(
                      value: controller.selectedSubcategory.value,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                        ),
                      ),
                      hint: Text(controller.subCategoryList.isEmpty ? 'Subcategory not found' : 'Select a subcategory'),
                      onChanged: controller.subCategoryList.isEmpty
                          ? null
                          : (SubCategoryData? newValue) {
                        controller.selectedSubcategory.value = newValue!;
                      },
                      items: controller.subCategoryList.isNotEmpty
                          ? controller.subCategoryList
                          .map((subcategory) => DropdownMenuItem<SubCategoryData>(
                        value: subcategory,
                        child: Text(subcategory.subcategory_name ?? ''),
                      ))
                          .toList()
                          : [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Subcategory not found'),
                        )
                      ],
                    );
                  }),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(left: 20,top: 10),
              child: Text(
                "Add Image",
                style: AppFonts.rubik.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                ),
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.pickedImages.length + 1, // +1 for the camera button
                    itemBuilder: (context, index) {
                      if (index == controller.pickedImages.length) {
                        return InkWell(
                          onTap: () {
                            controller.selectMultipleImages();
                          },
                          child:
                          Container(
                            margin: const EdgeInsets.all(8),
                            width: 150,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.primaryColor,
                              size: 50,
                            ),
                          ),
                        );
                      }

                      // Display selected image
                      final image = controller.pickedImages[index];
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            width: 150,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(image.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                controller.pickedImages.removeAt(index);
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.primaryColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),

            Obx(() => Align(
              alignment: Alignment.bottomCenter, // Align to bottom center

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PrimaryButton(
                  textColor: AppColors.white,
                  height: 52,
                  btnColor: AppColors.primaryColor,
                  onPressed: () {
                    print("Phone Number: ${controller.phoneController.text}");
                    controller.addCard();
                  },
                  isLoading: controller.isCardLoading.value,
                  title: "Submit",
                  borderColor: AppColors.primaryColor,
                  hasIcon: false,
                ),
              ),
            )),


          ],
        ),
      ),
    );
  }

  void showMultiCountryPicker(
      BuildContext context,
      RxList<CountryData> selectedCountries,
      List<CountryData> allCountries,
      ) {
    List<CountryData> tempSelected = [...selectedCountries];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Countries'),
          content: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.9,
            child: ListView.builder(
              itemCount: allCountries.length,
              itemBuilder: (context, index) {
                final country = allCountries[index];
                final isSelected = tempSelected.any(
                      (c) => c.country_name == country.country_name,
                );

                return InkWell(
                  onTap: () {
                    if (isSelected) {
                      tempSelected.removeWhere(
                            (c) => c.country_name == country.country_name,
                      );
                    } else {
                      tempSelected.add(country);
                    }
                    (context as Element).markNeedsBuild();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Image.network(
                          "${controller.apiClient.url}${country.flag}",
                          width: 24,
                          height: 16,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.flag_outlined, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            country.country_name ?? '',
                            softWrap: true,
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          activeColor: AppColors.primaryColor,
                          onChanged: (bool? value) {
                            if (value == true) {
                              tempSelected.add(country);
                            } else {
                              tempSelected.removeWhere(
                                    (c) => c.country_name == country.country_name,
                              );
                            }
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: AppColors.primaryColor)),
            ),
            ElevatedButton(
              onPressed: () {
                selectedCountries.assignAll(tempSelected);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Confirm", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget buildDetail(AddCardController controller, TextEditingController controllerName, String hint, int maxLines, String aboveText) {
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
          SizedBox(height: 5),
          TextFormField(
            controller: controllerName,
            decoration: InputDecoration(
              hintText: hint,
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
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}

