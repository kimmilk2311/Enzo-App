import 'package:flutter/material.dart';
import 'package:vendor_store/views/screens/authentication/login_page.dart';
import 'package:vendor_store/controllers/vendor_auth_controller.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../resource/asset/app_images.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final VendorAuthController _vendorAuthController = VendorAuthController();

  String fullName = "";
  String email = "";
  String password = "";
  bool isLoading = false;

  // Xu ly dang ky
  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await _vendorAuthController.signUpVendor(
        fullName: fullName,
        email: email,
        password: password,
        context: context,
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Đăng ký",
                            style: AppStyles.STYLE_36_BOLD.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Họ và Tên
                        AppTextField(
                          hintText: "Nhập họ và tên",
                          prefixImage: AppImages.icUser,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Vui lòng nhập họ và tên";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            fullName = value;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Email
                        AppTextField(
                          hintText: "Nhập email",
                          prefixImage: AppImages.icUser,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Vui lòng nhập email";
                            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return "Email không hợp lệ";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Mật khẩu
                        AppTextField(
                          hintText: "Nhập mật khẩu",
                          prefixImage: AppImages.icPassword,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return "Mật khẩu phải có ít nhất 6 ký tự";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Nút Đăng ký
                        AppButton(
                          text: "Đăng ký",
                          isLoading: isLoading,
                          onPressed: registerUser,
                          color: AppColors.bluePrimary,
                          textColor: AppColors.white,
                        ),
                        const SizedBox(height: 20),

                        // Chuyển sang trang Đăng nhập
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Bạn đã có tài khoản?",
                              style: AppStyles.STYLE_16.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                "Đăng nhập",
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
}
