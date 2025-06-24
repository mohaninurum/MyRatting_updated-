import 'package:card/app/modules/create_account_module/create_acoount_controller.dart';
import 'package:get/get.dart';

class CreateAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateAccountController());
  }
}
