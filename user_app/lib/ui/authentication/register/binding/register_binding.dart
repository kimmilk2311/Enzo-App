import 'package:get/get.dart';
import 'package:multi_store/ui/authentication/register/controller/register_controller.dart';

import '../../login/controller/login_controller.dart';

class RegisterBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
    Get.put<LoginController>(LoginController());

  }
}
