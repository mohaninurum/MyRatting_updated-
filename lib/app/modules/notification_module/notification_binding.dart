import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';

import 'notifcation_controller.dart';

class NotificationBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => NotificationController());

  }

}