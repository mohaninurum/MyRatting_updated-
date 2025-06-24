import 'package:card/app/modules/card_detail_module/card_detail_controller.dart';
import 'package:get/get.dart';

class CardDetailBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> CardDetailController());
    // TODO: implement dependencies
  }
  
}