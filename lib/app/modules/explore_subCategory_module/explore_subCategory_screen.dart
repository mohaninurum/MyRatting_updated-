import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../utils/appColors.dart';
import '../../utils/strings.dart';
import 'explore_subCategory_controller.dart';

class ExploreSubcategoryScreen extends StatelessWidget {
   ExploreSubcategoryScreen({super.key});
  final ExploreSubCategoryController controller = Get.put(ExploreSubCategoryController());

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
        leading: InkWell(
           onTap: (){
             Get.back();
           },
            child: Icon(Icons.arrow_back_ios)),
      ),

      body: Obx(() {
        if (controller.isSubCategoryLoading.value) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primaryColor,
              radius: 16,
            ),
          );
        }

        if (controller.subCategoryList.isEmpty) {
          return const Center(
            child: Text(
              "No Subcategories found.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                ),
                itemCount: controller.subCategoryList.length,
                itemBuilder: (context, index) {
                  var category = controller.subCategoryList[index];

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.EXPLORE_TOP_CARD, arguments: {
                        "subCategoryId": category.subcategory_id_PK.toString(),
                      });
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias, // Makes sure children don't overflow
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
                            ),
                          ),

                          // Gradient Overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black54, Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Text(
                                category.subcategory_name ?? "",
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
      }),
    );
  }

}
