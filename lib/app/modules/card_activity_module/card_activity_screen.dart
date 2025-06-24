import 'dart:convert';

import 'package:card/app/routes/app_pages.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:card/app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'card_activity_controller.dart'; // Import the controller
class CardActivityScreen extends StatelessWidget {
  const CardActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CardActivityController controller = Get.put(CardActivityController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          Strings.cardActivity,
          style: AppFonts.rubik.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,

      ),
      body: Obx(() {
        if (controller.isCardLoading.value) {
          return Center(child: CupertinoActivityIndicator(
            color: AppColors.primaryColor,
              radius: 18,
          ));
        }

        if (controller.activityList.isEmpty) {
          return Center(
            child: Text(
              "No cards found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 3 / 4,
          ),
          itemCount: controller.activityList.length,
          itemBuilder: (context, index) {
            final activity = controller.activityList[index];
            final String parsedImage = getParsedImagePath(activity.image);

            return InkWell(
              onTap: () {
                Get.toNamed(Routes.CARD_DETAIL, arguments: {
                  "cardId": activity.card_id_PK.toString(),
                });
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      parsedImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/monstera-8477880_640.jpg',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CupertinoActivityIndicator());
                      },
                    ),


                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                            ),
                          ),


                          Wrap(
                            spacing: 0,
                            runSpacing: 0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                activity.subcategory_name ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                                ),
                              ),
                              if (activity.is_like == 1)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red),
                                    SizedBox(width: 5),
                                    Text(
                                      "Liked",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              if (activity.is_dislike == 1)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.thumb_down, color: Colors.blue),
                                    SizedBox(width: 5),
                                    Text(
                                      "Disliked",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              if (activity.is_superlike == 2)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow),
                                    SizedBox(width: 5),
                                    Text(
                                      "Super Liked",
                                      style: TextStyle(color: Colors.yellow),
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
              ),
            );
          },
        );


      }),
    );
  }
  String getParsedImagePath(String? imageUrl) {
    const String baseUrl = 'http://myephysician.com/myratingsystem/uploads/icons/';
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith(baseUrl) && imageUrl.substring(baseUrl.length).trim().startsWith('[')) {
      try {
        String cleanedImage = imageUrl.substring(baseUrl.length).trim();
        List<dynamic> images = jsonDecode(cleanedImage);
        if (images.isNotEmpty && images[0] is String) {
          return baseUrl + images[0];
        }
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
    return imageUrl;
  }

}



