import 'package:flutter/material.dart';
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
  String phone = "";
  String address = "";
  String password = "";
  bool isLoading = false;

  // Xử lý đăng ký
  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await _vendorAuthController.signUpVendor(
        fullName: fullName,
        email: email,
        phone: phone,
        address: address,
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Đăng ký",
                style: AppStyles.STYLE_36_BOLD.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),

              AppTextField(
                hintText: "Nhập họ và tên",
                prefixImage: AppImages.icUser,
                onChanged: (value) => fullName = value,
                validator: (value) => value!.isEmpty ? "Vui lòng nhập họ và tên" : null,
              ),
              const SizedBox(height: 15),

              AppTextField(
                hintText: "Nhập email",
                prefixImage: AppImages.icCart,
                onChanged: (value) => email = value,
                validator: (value) => value!.isEmpty ? "Vui lòng nhập email" : null,
              ),
              const SizedBox(height: 15),

              AppTextField(
                hintText: "Nhập số điện thoại",
                prefixImage: AppImages.icUser,
                onChanged: (value) => phone = value,
                validator: (value) => value!.isEmpty ? "Vui lòng nhập số điện thoại" : null,
              ),
              const SizedBox(height: 15),

              AppTextField(
                hintText: "Nhập mật khẩu",
                prefixImage: AppImages.icPassword,
                isPassword: true,
                onChanged: (value) => password = value,
                validator: (value) => value!.length < 6 ? "Mật khẩu phải có ít nhất 6 ký tự" : null,
              ),
              const SizedBox(height: 20),

              AppButton(
                text: "Đăng ký",
                isLoading: isLoading,
                onPressed: registerUser,
                color: AppColors.bluePrimary,
                textColor: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
