import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/common/base/widgets/common/app_text_field.dart';
import 'package:multi_store/controller/auth_controller.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

import '../../register/screen/register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  String loginInput = '';
  String password = '';
  bool isLoading = false;

  Future<void> _loginUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _authController.signInUsers(
        context: context,
        loginInput: loginInput,
        password: password,
        ref: ref,
      );
    } catch (e) {
    } finally {
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Đăng nhập",
                              style: AppStyles.STYLE_36_BOLD.copyWith(color: AppColors.black80),
                            ),
                            Text(
                              "Chào mừng bạn quay trở lại",
                              style: AppStyles.STYLE_18.copyWith(color: AppColors.black80),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      AppTextField(
                        hintText: "Email hoặc số điện thoại",
                        prefixImage: AppImages.icUser,
                        onChanged: (value) => loginInput = value,
                      ),
                      const SizedBox(height: 15),
                      AppTextField(
                        hintText: "Mật khẩu",
                        prefixImage: AppImages.icPassword,
                        isPassword: true,
                        onChanged: (value) => password = value,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Quên mật khẩu
                          },
                          child: Text(
                            "Quên mật khẩu?",
                            style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        text: "Đăng nhập",
                        isLoading: isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loginUser();
                          }
                        },
                        color: AppColors.bluePrimary,
                        textColor: AppColors.white,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Chưa có tài khoản?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ));
                            },
                            child: Text(
                              " Đăng ký ngay",
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
