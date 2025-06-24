import 'package:card/app/modules/explore_category_module/explore_category_controller.dart';
import 'package:get/get.dart';

class ExploreCategoryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ExploreCategoryController());
    // TODO: implement dependencies
  }

}