import 'package:card/app/modules/add_card_module/add_card_controller.dart';
import 'package:card/app/modules/add_card_module/add_card_page.dart';
import 'package:card/app/modules/card_activity_module/card_activity_controller.dart';
import 'package:card/app/modules/explore_category_module/explore_category_screen.dart';
import 'package:card/app/modules/profile_module/profile_controller.dart';
import 'package:card/app/modules/profile_module/profile_page.dart';
import 'package:card/app/modules/swipe_card_module/swipe_card_controller.dart';
import 'package:card/app/modules/swipe_card_module/swipe_card_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../card_activity_module/card_activity_screen.dart';
import '../explore_category_module/explore_category_controller.dart';
class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  var showLoader = false.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
    update();
  }

  final List<Widget> screens = [
    SwipeCardPage(),
    AddCardPage(),
    ExploreCategoryScreen(),
    CardActivityScreen(),
    ProfilePage(),
  ];
}


