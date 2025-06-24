import 'package:card/app/modules/term&condition_module/term&condition_controller.dart';
import 'package:get/get.dart';

class TermConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TermConditionController());
  }
}
