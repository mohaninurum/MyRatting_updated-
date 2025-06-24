import 'package:card/app/modules/repot_module/report_controller.dart';
import 'package:get/get.dart';

class ReportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ReportController());
    // TODO: implement dependencies
  }

}