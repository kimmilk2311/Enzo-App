import 'package:get/get.dart';


import '../../../../common/base/controller/base_controller.dart';
import '../../../../common/base/storage/local_data.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/extension_utils.dart';

class SplashController extends BaseController {
  static SplashController get to => Get.find<SplashController>();

  @override
  void onInit() {
    super.onInit();
    getCommon();
  }

  Future<void> getCommon() async {
    navigateToHome();
  }

  Future<void> navigateToHome() async {
    Future.delayed(Duration(seconds: random(2, 4)), () async {
      onNavigate();
    });
  }

  void onNavigate() {
    if (LocalData.shared.isLogged.isTrue) {
      Get.offAllNamed(PageName.mainPage);
    } else {
      Get.offAllNamed(PageName.startedPage);
    }
  }
}
