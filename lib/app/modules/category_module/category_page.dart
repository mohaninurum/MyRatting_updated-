import 'dart:convert';

import 'package:card/app/modules/category_module/category_controller.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';

import '../../routes/app_pages.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';
import '../add_card_module/add_card_controller.dart';
import '../dashboard_module/dashboard_controller.dart';
import '../profile_module/profile_controller.dart';
import '../swipe_card_module/swipe_card_controller.dart';

class CategoryPage extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Choose Category",
          style: AppFonts.rubik.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: SizedBox.shrink(),
        actions: [
          InkWell(
              child: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final isSelectionEmpty =
                    controller.selectedCategorySubcategoryMap.isEmpty ||
                        controller.selectedCategorySubcategoryMap.values
                            .every((list) => list.isEmpty);

                if (isSelectionEmpty) {
                  AppUtils.showSnackbarSuccess(
                    title: "Required",
                    message: "Please select at least one subcategory",
                    icon: Icon(Icons.cached, color: Colors.white),
                  );
                  return;
                }

                final List<Map<String, dynamic>> filters =
                    controller.selectedCategorySubcategoryMap.entries.map((entry) {
                  final categoryId = entry.key;
                  final subcategoryIds = entry.value;

                  print("Category ID: $categoryId");
                  print("Subcategory IDs: $subcategoryIds");

                  return {
                    "category_id": categoryId,
                    "subcategory_ids": subcategoryIds,
                  };
                }).toList();

                print("Final Filters: $filters");

                await SecureStorage()
                    .writeSecureData("filters", jsonEncode({"filters": filters}));

                if (Get.isRegistered<DashboardController>()) {
                  Get.delete<DashboardController>(force: true);
                }
                if (Get.isRegistered<SwipeCardController>()) {
                  Get.delete<SwipeCardController>(force: true);
                }
                if (Get.isRegistered<AddCardController>()) {
                  Get.delete<AddCardController>(force: true);
                }
                if (Get.isRegistered<ProfileController>()) {
                  Get.delete<ProfileController>(force: true);
                }

                Get.toNamed(Routes.DASHBOARD);
              }),
          SizedBox(width: 15),
        ],
      ),
      body: controller.categoryList.isEmpty && controller.categoryList == null
          ? Center(child: Text("No Cateogries Found"))
          : Row(
              children: [
                Container(
                  width: 120,
                  color: AppColors.primaryColor,
                  child: GetBuilder<CategoryController>(
                    builder: (controller) {
                      return Obx(() => Align(
                                alignment: Alignment.topCenter,
                                child: ReorderableColumn(
                                  scrollController:
                                      controller.reorderableScrollController,
                                  children: List.generate(
                                    controller.categoryList.length,
                                    (index) {
                                      final category = controller.categoryList[index];
                                      final isSelected = controller.selectedCategories
                                          .contains(category.category_id_PK);
                                      return GestureDetector(
                                        key: ValueKey(category.category_id_PK),
                                        onTap: () {
                                          controller.toggleCategorySelection(category);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected ? Colors.green : Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Image.network(
                                                category.icon ?? '',
                                                height: 35,
                                                width: 35,
                                                errorBuilder:
                                                    (context, error, stackTrace) => Icon(
                                                  Icons.cookie,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.black,
                                                  size: 35,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                category.category_name ?? '',
                                                textAlign: TextAlign.center,
                                                style: AppFonts.rubik.copyWith(
                                                  fontSize: 14,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  onReorder: (oldIndex, newIndex) {
                                    controller.onReorder(oldIndex, newIndex);
                                  },
                                ),
                              )
                          /*ListView.builder(
                            itemCount: controller.categoryList.length,
                            itemBuilder: (context, index) {
                              final category = controller.categoryList[index];
                              final isSelected = controller.selectedCategories
                                  .contains(category.category_id_PK);

                              return GestureDetector(
                                onTap: () {
                                  controller.toggleCategorySelection(category);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.green : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        category.icon ?? '',
                                        height: 35,
                                        width: 35,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Icon(
                                          Icons.cookie,
                                          color: isSelected ? Colors.white : Colors.black,
                                          size: 35,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        category.category_name ?? '',
                                        textAlign: TextAlign.center,
                                        style: AppFonts.rubik.copyWith(
                                          fontSize: 14,
                                          color: isSelected ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )*/
                          );
                    },
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isSubCategoryLoading.value) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    if (controller.selectedCategories.isEmpty) {
                      return const Center(child: Text("Select a category"));
                    }

                    if (controller.subCategoryList.isEmpty) {
                      return const Center(child: Text("No subcategories found"));
                    }

                    return ListView.builder(
                      itemCount: controller.subCategoryList.length,
                      itemBuilder: (context, index) {
                        final subcategory =
                            controller.subCategoryList[index].subcategory_name ?? "";
                        final categoryId =
                            controller.subCategoryList[index].category_id_FK ?? 0;
                        final subcategoryId =
                            controller.subCategoryList[index].subcategory_id_PK ?? 0;

                        return Obx(() => CheckboxListTile(
                              activeColor: Colors.blue,
                              title: Text(
                                subcategory,
                                style: AppFonts.rubik.copyWith(),
                              ),
                              value: controller.selectedCategorySubcategoryMap[categoryId]
                                      ?.contains(subcategoryId.toString()) ??
                                  false, // Convert to String
                              onChanged: (bool? value) {
                                controller.toggleSubcategory(
                                    categoryId, subcategoryId); // Toggle by ID
                              },
                            ));
                      },
                    );
                  }),
                ),
              ],
            ),
    );
  }
}
