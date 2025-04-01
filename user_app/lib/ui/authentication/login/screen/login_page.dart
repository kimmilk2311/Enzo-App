import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/common/base/widgets/common/app_text_field.dart';
import 'package:multi_store/common/base/widgets/base_page_widget.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/routes/app_routes.dart';
import 'package:multi_store/ui/authentication/login/controller/login_controller.dart';

class LoginPage extends BasePage<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<LoginController>(LoginController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Image.asset(
            AppImages.imgBubble,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "login".tr,
                                style: AppStyles.STYLE_36_BOLD.copyWith(color: AppColors.black80),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "titleLogin".tr,
                                style: AppStyles.STYLE_18.copyWith(color: AppColors.black80),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      // Email Field
                      AppTextField(
                        hintText: "enterEmailOrPhone".tr,
                        prefixImage: AppImages.icUser,
                        onChanged: (value) {
                          controller.loginInput = value;
                        },
                      ),

                      const SizedBox(height: 15),

                      // Password Field
                      AppTextField(
                        hintText: "enterPassword".tr,
                        prefixImage: AppImages.icPassword,
                        isPassword: true,
                        onChanged: (value) {
                          controller.password = value;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "forgotPassword".tr,
                            style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Obx(() => AppButton(
                        text: "login".tr,
                        isLoading: controller.isLoading.value,
                        onPressed: () {
                          controller.loginUser(context);
                        },
                        color: AppColors.bluePrimary,
                        textColor: AppColors.white,
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}//