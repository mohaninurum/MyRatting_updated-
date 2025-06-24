import 'package:card/app/modules/submit_detail_module/submit_detail_controller.dart';
import 'package:get/get.dart';

class SubmitDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubmitDetailController());
  }
}
