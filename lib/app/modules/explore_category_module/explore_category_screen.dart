import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../utils/appColors.dart';
import '../../utils/strings.dart';
import 'explore_category_controller.dart';


class ExploreCategoryScreen extends StatelessWidget {
  final ExploreCategoryController controller = Get.put(ExploreCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          Strings.exploreCardRank,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: SizedBox.shrink(),
      ),

      body: GetBuilder<ExploreCategoryController>(
        builder: (controller) {
          if (controller.isCategoryLoading.value) {
            return const Center(child: CupertinoActivityIndicator(
              color: AppColors.primaryColor,
              radius: 16,
            ));
          }

          if (controller.categoryList.isEmpty) {
            return const Center(
              child: Text(
                "No categories found.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Column(
            children: [
              // Categories Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0.0,
                  ),
                  itemCount: controller.categoryList.length,
                  itemBuilder: (context, index) {
                    var category = controller.categoryList[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.EXPLORE_SUBCATEGORY, arguments: {
                          "categoryId": category.category_id_PK.toString()
                        });
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                category.icon ?? "",
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CupertinoActivityIndicator(), // You can customize this
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/monstera-8477880_640.jpg', // Your local placeholder image
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),


                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.black54, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Text(
                                  category.category_name ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(blurRadius: 1, color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
