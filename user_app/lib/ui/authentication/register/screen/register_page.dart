import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/common/base/widgets/common/app_text_field.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/controller/auth_controller.dart';
import 'package:multi_store/ui/authentication/login/screen/login_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String email = '';
  String phone = '';
  String password = '';
  File? imageFile;
  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source, imageQuality: 70);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _registerUser(BuildContext context) async {
    setState(() => isLoading = true);
    final base64Image = imageFile != null ? base64Encode(await imageFile!.readAsBytes()) : '';

    await AuthController().signUpUsers(
      context: context,
      email: email,
      phone: phone,
      fullName: fullName,
      password: password,
      image: base64Image,
      address: '',
    );

    setState(() => isLoading = false);
  }

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
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Chụp ảnh"),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
            child: Image.asset(AppImages.imgBrSignUp, fit: BoxFit.cover),
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
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Đăng ký",
                            style: AppStyles.STYLE_36_BOLD.copyWith(color: AppColors.black),
                          ),
                        ),
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () => _showImagePicker(context),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.gold50,
                            backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                            child: imageFile == null
                                ? const Icon(Icons.camera_alt, size: 40, color: Colors.blue)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),

                        AppTextField(
                          hintText: "Họ và tên",
                          prefixImage: AppImages.icUser,
                          onChanged: (value) => fullName = value,
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          hintText: "Email",
                          prefixImage: AppImages.icUser,
                          onChanged: (value) => email = value,
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          hintText: "Số điện thoại",
                          prefixImage: AppImages.icUser,
                          onChanged: (value) => phone = value,
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          hintText: "Mật khẩu",
                          prefixImage: AppImages.icPassword,
                          isPassword: true,
                          onChanged: (value) => password = value,
                        ),
                        const SizedBox(height: 20),

                        AppButton(
                          text: "Đăng ký",
                          isLoading: isLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerUser(context);
                            }
                          },
                          color: AppColors.bluePrimary,
                          textColor: AppColors.white,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Bạn đã có tài khoản?"),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ));
                              },
                              child: Text(
                                " Đăng nhập",
                                style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
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
