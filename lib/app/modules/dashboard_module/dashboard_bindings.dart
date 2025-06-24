import 'package:card/app/modules/dashboard_module/dashboard_controller.dart';
import 'package:get/get.dart';

import '../add_card_module/add_card_controller.dart';
import '../card_activity_module/card_activity_controller.dart';
import '../explore_category_module/explore_category_controller.dart';
import '../profile_module/profile_controller.dart';
import '../swipe_card_module/swipe_card_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}
