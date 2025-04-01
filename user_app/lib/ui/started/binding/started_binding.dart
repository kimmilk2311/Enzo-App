import 'package:get/get.dart';
import 'package:multi_store/ui/started/controller/started_controller.dart';

class StartedBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<StartedController>(StartedController());
  }

}