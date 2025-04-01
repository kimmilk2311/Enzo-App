import 'package:flutter/material.dart';
import 'package:vendor_store/controllers/vendor_auth_controller.dart';
import 'package:vendor_store/views/screens/authentication/register_page.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../resource/asset/app_images.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final VendorAuthController _authController = VendorAuthController();

  late String email;

  late String password;
  late bool isLoading = false;

  // Hàm xử lý đăng nhập
  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await _authController.signInVendor(
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
                  key: _formKey,
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
                                "Đăng nhập",
                                style: AppStyles.STYLE_36_BOLD.copyWith(color: AppColors.black80),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Email Field
                      AppTextField(
                        hintText: "Nhâp Email",
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
                      const SizedBox(height: 15),

                      // Password Field
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
                      const SizedBox(height: 10),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Quên mật khẩu?",
                            style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Login Button
                      AppButton(
                        text: "Đăng nhập",
                        isLoading: isLoading,
                        onPressed: loginUser,
                        color: AppColors.bluePrimary,
                        textColor: AppColors.white,
                      ),

                      const SizedBox(height: 10),
                      AppButton(
                        text: "Đăng ký ngay",
                        isLoading: isLoading,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                        },
                        color: AppColors.white40,
                        textColor: AppColors.bluePrimary,
                      ),

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
}
