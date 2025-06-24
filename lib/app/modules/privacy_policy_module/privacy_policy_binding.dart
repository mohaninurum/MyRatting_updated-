import 'package:card/app/modules/privacy_policy_module/privacy_policy_controller.dart';
import 'package:get/get.dart';

class PrivacyPolicyBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyPolicyController());
    // TODO: implement dependencies
  }

}