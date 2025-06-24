import 'package:card/app/modules/add_card_module/add_card_controller.dart';
import 'package:get/get.dart';

class AddCardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddCardController());
  }
}
