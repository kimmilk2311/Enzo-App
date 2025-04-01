import 'package:get/get.dart';
import 'package:multi_store/ui/authentication/login/controller/login_controller.dart';
import 'package:multi_store/ui/main/controller/main_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
    Get.put<MainController>(MainController());
  }
}
