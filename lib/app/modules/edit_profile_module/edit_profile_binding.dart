import 'package:card/app/modules/edit_profile_module/edit_profile_controller.dart';
import 'package:get/get.dart';

class EditProfileBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> EditProfileController());
  }

}