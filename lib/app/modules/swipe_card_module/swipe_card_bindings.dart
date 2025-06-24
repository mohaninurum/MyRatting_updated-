import 'package:card/app/modules/swipe_card_module/swipe_card_controller.dart';
import 'package:get/get.dart';

class SwipeCardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SwipeCardController(),fenix: true);
  }
}