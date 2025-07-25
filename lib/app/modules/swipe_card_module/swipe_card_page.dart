import 'package:cached_network_image/cached_network_image.dart';
import 'package:card/app/modules/swipe_card_module/swipe_card_controller.dart';
import 'package:card/app/response_model/get_card_response/get_card_response.dart';
import 'package:card/app/utils/appColors.dart';
import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../routes/app_pages.dart';
import '../dashboard_module/dashboard_page.dart';

class SwipeCardPage extends StatelessWidget {
  SwipeCardPage({super.key});
  final SwipeCardController controller = Get.put(SwipeCardController());
  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: Get.context!,
      builder: (context) {
        return ExitDialogScreen(isExitDialog: true);
      },
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    SwipeItem currentCard;
    CardData cardData;
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 30,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      "My Rating App",
                      style: AppFonts.IBMPlexSans.copyWith(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.NOTIFICATION);
                      },
                      child: Icon(Icons.notifications_active),
                    ),
                  ],
                ),
              ),
              GetBuilder<SwipeCardController>(
                builder: (controller) {
                  if (controller.isCard.value && controller.swipeItems.isEmpty) {
                    return const Center(
                      child: CupertinoActivityIndicator(radius: 20),
                    );
                  }

                  if (controller.swipeItems.isEmpty) {
                    return const Center(
                      child: Text(
                        "No valid cards to show",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      SwipeCards(
                        matchEngine: controller.matchEngine!,
                        itemBuilder: (context, index) {
                          final currentCard = controller.swipeItems[index];
                          final cardData = controller.subCategoryList[index];
                          // final imageIndex = controller.currentImageIndex.value;
                          // final image = imageIndex < currentCard.content.length
                          //     ? currentCard.content[imageIndex]
                          //     : currentCard.content.last;
                          return Center(
                            child: Container(
                              height: screenHeight / 1.6,
                              width: screenWidth / 1.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.white,
                                border: Border.all(color: AppColors.primaryColor, width: 7),
                              ),
                              child: Stack(
                                children: [
                                  Obx(() {
                                    final imageIndex = controller.currentImageIndex.value;
                                    final image = imageIndex < currentCard.content.length ? currentCard.content[imageIndex] : currentCard.content.last;
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(53),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        // loadingBuilder: (context, child, progress) {
                                        //   if (progress == null) return child;
                                        //   return const Center(
                                        //       child: CupertinoActivityIndicator());
                                        // },
                                        imageUrl: image,
                                        errorWidget: (context, url, error) {
                                          return Image.asset(
                                            'assets/images/monstera-8477880_640.jpg',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          );
                                        },
                                        placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                                      ),
                                    );
                                  }),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [AppColors.primaryColor, Colors.transparent],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(52),
                                          bottomRight: Radius.circular(52),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (controller.currentImageIndex.value > 0) {
                                        controller.currentImageIndex.value--;
                                      }
                                      print("Clicked Left");
                                    },
                                    child: Container(
                                      width: 50,
                                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(53), topLeft: Radius.circular(53))),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        final currentCard = controller.swipeItems[index];
                                        if (controller.currentImageIndex.value < currentCard.content.length - 1) {
                                          controller.currentImageIndex.value++;
                                        }
                                        print("Clicked Right");
                                      },
                                      child: Container(
                                        width: 50,
                                        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.only(bottomRight: Radius.circular(53), topRight: Radius.circular(53))),
                                      ),
                                    ),
                                  ),
/*
                                  Positioned(
                                    top: 15,
                                    right: 15,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Obx(() => Text(
                                            "${controller.currentImageIndex.value + 1} / ${currentCard.content.length}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                    ),
                                  ),
*/
                                  Positioned(
                                    bottom: 60,
                                    left: 20,
                                    right: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.CARD_DETAIL, arguments: {
                                          "cardId": cardData.card_id_PK.toString(),
                                        });
                                        print("Imagesssss===>${currentCard.content}");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cardData.title ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              cardData.subcategory_name ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/images/rewind.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          onPressed: () {
                                            controller.rewindPreviousCard(index);
                                          },
                                        ),
                                        Obx(() => IconButton(
                                              icon: SvgPicture.asset(
                                                controller.isDisLiked.value ? 'assets/images/cancel.svg' : "assets/images/canceled.svg",
                                                width: 30,
                                                height: 30,
                                              ),
                                              onPressed: () {
                                                controller.currentImageIndex.value = index;
                                                controller.swipeHistory.add(controller.swipeItems[index]);
                                                controller.subCategoryHistory.add(controller.subCategoryList[index]);
                                                controller.matchEngine?.currentItem?.nope();
                                                controller.disLikeApi(cardData.card_id_PK.toString());
                                              },
                                            )),
                                        Obx(() => IconButton(
                                              icon: SvgPicture.asset(
                                                controller.isLiked.value ? 'assets/images/like.svg' : 'assets/images/liked.svg',
                                                width: 35,
                                                height: 35,
                                              ),
                                              onPressed: () {
                                                controller.currentImageIndex.value = index;
                                                // controller.swipeHistory.add(controller.swipeItems[index]);
                                                // controller.subCategoryHistory.add(controller.subCategoryList[index]);
                                                controller.matchEngine?.currentItem?.like();
                                                controller.likeApi(cardData.card_id_PK.toString());
                                              },
                                            )),
                                        Obx(() => IconButton(
                                              icon: SvgPicture.asset(
                                                controller.isSuperLike.value ? "assets/images/superlike.svg" : 'assets/images/superLiked.svg',
                                                width: 35,
                                                height: 35,
                                              ),
                                              onPressed: () {
                                                controller.currentImageIndex.value = index;
                                                controller.matchEngine?.currentItem?.superLike();
                                                controller.superLikeApi(cardData.card_id_PK.toString());
                                              },
                                            )),
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/images/share.svg',
                                            width: 25,
                                            height: 25,
                                          ),
                                          onPressed: () {
                                            /*final imageIndex = controller
                                                .currentImageIndex.value;
                                            final currentImage =
                                            imageIndex <
                                                currentCard
                                                    .content.length
                                                ? currentCard
                                                .content[imageIndex]
                                                : currentCard.content.last;

                                            final cardId =
                                            cardData.card_id_PK.toString();
                                            final title =
                                                cardData.title ?? '';
                                            final description =
                                                cardData.description ?? '';
                                            final deepLink =
                                                "https://myRatingSystem.com/card?cardId=$cardId";
                                            final shareMessage = '''
                            $title
                            $description
                            $currentImage
                            Check it out: $deepLink
                            ''';*/
                                            final shareMessage = '''
                                                         Discover and rate products with RatingApp!
                                                         Share your experiences, explore product reviews, and help others make better choices.
                                                         Download now:https://play.google.com/store/apps/details?id=com.myrating.app
                            ''';
                                            Share.share(shareMessage);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemChanged: (p0, p1) {
                          controller.currentImageIndex.value = 0;
                        },
                        onStackFinished: () {
                          controller.onAllCardsSwiped();
                        },
                        leftSwipeAllowed: true,
                        rightSwipeAllowed: true,
                        upSwipeAllowed: true,
                        likeTag: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0, right: 30.0),
                            child: Transform.rotate(
                              angle: 0.3,
                              child: Image.asset(
                                "assets/images/heart.png",
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                        nopeTag: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 30.0),
                            child: Transform.rotate(
                              angle: -0.3,
                              child: Image.asset(
                                "assets/images/nope.png",
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(() => controller.allCardsSwiped.value
                          ? Center(
                              child: Text(
                                "All cards swiped!",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          : const SizedBox.shrink()),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
