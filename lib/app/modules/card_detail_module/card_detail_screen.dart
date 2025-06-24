import 'package:cached_network_image/cached_network_image.dart';
import 'package:card/app/modules/card_detail_module/card_detail_controller.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../routes/app_pages.dart';

class CardDetailScreen extends GetView<CardDetailController> {
  const CardDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Card Detail',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel
              if (controller.images.isNotEmpty)
                SizedBox(
                  height: 300,
                  width: double.infinity, // ensure full width container
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: controller.pageController,
                        itemCount: controller.images.length,
                        onPageChanged: (index) {
                          controller.currentIndex.value = index;
                        },
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            imageUrl: controller.images[index],
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                'assets/images/monstera-8477880_640.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              );
                            },
                            placeholder: (context, url) =>
                                const Center(child: CupertinoActivityIndicator()),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: controller.pageController,
                            count: controller.images.length,
                            effect: WormEffect(
                              dotWidth: 8.0,
                              dotHeight: 8.0,
                              spacing: 16.0,
                              dotColor: Colors.grey,
                              activeDotColor: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: controller.cardDetailData == null
                    ? const SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Report
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.cardDetailData?.title ?? "",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.REPORT, arguments: {
                                      "cardID":
                                          controller.cardDetailData?.card_id_PK.toString()
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.flag,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Subcategory
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                controller.cardDetailData?.subcategory_name ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Description
                            Text(
                              controller.cardDetailData?.description ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            (controller.cardDetailData?.additional_information == null ||
                                    controller.cardDetailData?.additional_information ==
                                        '' ||
                                    controller.cardDetailData?.additional_information ==
                                        {})
                                ? SizedBox()
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Additional Information",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                            (controller.cardDetailData?.additional_information == null ||
                                    controller.cardDetailData?.additional_information ==
                                        '' ||
                                    controller.cardDetailData?.additional_information ==
                                        {})
                                ? SizedBox()
                                : SizedBox(height: 10),

                            // Description
                            Text(
                              controller.cardDetailData?.additional_information ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
