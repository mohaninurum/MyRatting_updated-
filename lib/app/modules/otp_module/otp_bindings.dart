import 'package:card/app/modules/otp_module/otp_controller.dart';
import 'package:get/get.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => OtpController());
  }
}
