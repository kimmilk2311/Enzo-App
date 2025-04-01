import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // IMPORT image_picker
import 'package:multi_store/common/base/controller/base_controller.dart';
import 'package:multi_store/controller/auth_controller.dart';

class RegisterController extends BaseController {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = "";
  String fullName = "";
  String phone = "";
  String password = "";
  var isLoading = false.obs;
  var imageFile = Rx<File?>(null);

  // Hàm mở thư viện ảnh hoặc camera
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  // Hàm đăng ký người dùng có kèm ảnh
  void registerUser(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    // Chuyển ảnh thành base64 hoặc upload lên server (nếu cần)
    String imagePath = imageFile.value?.path ?? '';

    await _authController.signUpUsers(
      context: context,
      email: email,
      phone: phone,
      fullName: fullName,
      password: password,
      image: imagePath, // Gửi ảnh lên server
    ).whenComplete(() {
      isLoading.value = false;
    });
  }
}
