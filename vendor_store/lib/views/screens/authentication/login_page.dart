import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store/controllers/vendor_auth_controller.dart';
import 'package:vendor_store/views/screens/authentication/register_page.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../resource/asset/app_images.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_styles.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final VendorAuthController _authController = VendorAuthController();
  String loginInput = '';
  String password = '';
  bool isLoading = false;

  // Hàm xử lý đăng nhập
  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await _authController.signInVendor(
        loginInput: loginInput,
        password: password,
        context: context,
        ref: ref,
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
                      Text(
                        "Đăng nhập",
                        style: AppStyles.STYLE_36_BOLD.copyWith(color: AppColors.black80),
                      ),
                      const SizedBox(height: 20),

                      // Email hoặc Số điện thoại
                      AppTextField(
                        hintText: "Nhập Email hoặc số điện thoại",
                        prefixImage: AppImages.icUser,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Vui lòng nhập email hoặc số điện thoại";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          loginInput = value;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Mật khẩu
                      AppTextField(
                        hintText: "Nhập mật khẩu",
                        prefixImage: AppImages.icPassword,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return "Mật khẩu phải có ít nhất 6 ký tự";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Nút Đăng nhập
                      AppButton(
                        text: "Đăng nhập",
                        isLoading: isLoading,
                        onPressed: loginUser,
                        color: AppColors.bluePrimary,
                        textColor: AppColors.white,
                      ),
                      const SizedBox(height: 20),

                      // Nút chuyển sang Đăng ký
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Chưa có tài khoản? ",
                            style: AppStyles.STYLE_16.copyWith(color: AppColors.blackFont),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const RegisterPage();
                              }));
                            },
                            child: Text(
                              "Đăng ký",
                              style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                            ),
                          ),
                        ],
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
