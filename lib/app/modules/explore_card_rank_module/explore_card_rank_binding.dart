import 'package:card/app/modules/explore_card_rank_module/explore_card_rank_controller.dart';
import 'package:get/get.dart';

class ExploreCardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ExploreCardController());
    // TODO: implement dependencies
  }

}