import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/common/base/widgets/common/app_text_field.dart';
import 'package:multi_store/common/base/widgets/base_page_widget.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/routes/app_routes.dart';
import 'package:multi_store/ui/authentication/register/controller/register_controller.dart';

class RegisterPage extends BasePage<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight * 0.4,
            width: double.infinity,
            child: Image.asset(
              AppImages.imgBrSignUp,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "titleRegister".tr,
                            style: AppStyles.STYLE_36_BOLD.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Ô chọn ảnh đại diện
                        Obx(() => GestureDetector(
                          onTap: () => _showImagePicker(context),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.gold50,
                            backgroundImage: controller.imageFile.value != null
                                ? FileImage(controller.imageFile.value!)
                                : null,
                            child: controller.imageFile.value == null
                                ? const Icon(Icons.camera_alt, size: 40, color: Colors.blue)
                                : null,
                          ),
                        )),
                        const SizedBox(height: 20),

                        // Ô nhập họ tên
                        AppTextField(
                          hintText: "fullName".tr,
                          prefixImage: AppImages.icUser,
                          onChanged: (value) {
                            controller.fullName = value;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Ô nhập email
                        AppTextField(
                          hintText: "enterEmail".tr,
                          prefixImage: AppImages.icUser,
                          onChanged: (value) {
                            controller.email = value;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Ô nhập số điện thoại
                        AppTextField(
                          hintText: "enterPhone".tr,
                          prefixImage: AppImages.icUser,
                          onChanged: (value) {
                            controller.phone = value;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Ô nhập mật khẩu
                        AppTextField(
                          hintText: "enterPassword".tr,
                          prefixImage: AppImages.icPassword,
                          isPassword: true,
                          onChanged: (value) {
                            controller.password = value;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Nút đăng ký
                        Obx(() => AppButton(
                          text: "register".tr,
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            controller.registerUser(context);
                          },
                          color: AppColors.bluePrimary,
                          textColor: AppColors.white,
                        )),
                        const SizedBox(height: 20),

                        // Điều hướng đến đăng nhập
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "haveAccount".tr,
                              style: AppStyles.STYLE_16.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(PageName.loginPage);
                              },
                              child: Text(
                                "login".tr,
                                style: AppStyles.STYLE_16_BOLD.copyWith(
                                  color: AppColors.bluePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hiển thị bottom sheet chọn ảnh
  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Chọn từ thư viện"),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Chụp ảnh"),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
