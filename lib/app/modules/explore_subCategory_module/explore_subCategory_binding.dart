import 'package:card/app/modules/explore_subCategory_module/explore_subCategory_controller.dart';
import 'package:get/get.dart';

class ExploreSubCateogryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ExploreSubCategoryController());
    // TODO: implement dependencies
  }

}