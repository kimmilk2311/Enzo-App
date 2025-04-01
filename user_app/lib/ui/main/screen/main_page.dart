import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_store/common/base/widgets/common/app_navigation_bar.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import '../../../common/base/widgets/base_page_widget.dart';
import '../controller/main_controller.dart';

class MainPage extends BasePage<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<MainController>(MainController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => controller.pages[controller.pageIndex.value]),
      bottomNavigationBar: Obx(() => AppNavigationBar(
            selectedIndex: controller.pageIndex.value,
            onTabSelected: (index) {
              controller.changePage(index);
            },
          )),
    );
  }
}
