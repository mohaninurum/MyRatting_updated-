import 'package:card/app/modules/card_activity_module/card_activity_controller.dart';
import 'package:get/get.dart';

class CardActivityBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CardActivityController());

    // TODO: implement dependencies
  }

}