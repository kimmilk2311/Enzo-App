import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/common/base/widgets/base_page_widget.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/routes/app_routes.dart';
import 'package:multi_store/ui/started/controller/started_controller.dart';

class StartedPage extends BasePage<StartedController> {
  const StartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.imgLogo,
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "nameApp".tr,
                          style: AppStyles.STYLE_36_BOLD.copyWith(
                            color: AppColors.blackFont,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "titleStarted".tr,
                          style: AppStyles.STYLE_18.copyWith(
                            color: AppColors.greyDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              children: [
                AppButton(
                  text: "started".tr,
                  onPressed: () {
                    Get.toNamed(PageName.registerPage);
                  },
                  color: AppColors.bluePrimary,
                  textColor: AppColors.white,
                ),
             const SizedBox(height: 15),
             AppButton(
              text: "haveAccount".tr,
              onPressed: () {
                Get.toNamed(PageName.loginPage);
              },
              color: AppColors.white40,
              textColor: AppColors.blackFont,
            )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
