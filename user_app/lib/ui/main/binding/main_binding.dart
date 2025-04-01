import 'package:get/get.dart';
import 'package:multi_store/ui/authentication/login/controller/login_controller.dart';
import '../controller/main_controller.dart';


class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainController>(MainController());
    Get.put<LoginController>(LoginController());


  }
}
