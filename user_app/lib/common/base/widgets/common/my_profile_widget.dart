import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/provider/user_provider.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/services/manage_http_response.dart';

import '../../../../controller/auth_controller.dart';

class MyProfileWidget extends ConsumerStatefulWidget {
  final String? image;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? address;

  const MyProfileWidget({
    super.key,
     this.image,
    this.fullName,
    this.phone,
     this.email,
    this.address,
  });

  @override
  ConsumerState<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends ConsumerState<MyProfileWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.fullName);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    addressController = TextEditingController(text: widget.address ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _updateUserProfile() async {
    final user = ref.read(userProvider);

    if (user == null) {
      showSnackBar(context, "Không tìm thấy thông tin người dùng");
      return;
    }

    final newAddress = addressController.text.trim();

    if (nameController.text == user.fullName &&
        phoneController.text == user.phone &&
        emailController.text == user.email &&
        newAddress != user.address) {
      await AuthController().updateUserLocation(
        context: context,
        id: user.id,
        address: newAddress, ref: ref,
      );

      ref.read(userProvider.notifier).recreateUserState(address: newAddress);
    } else {
      await AuthController().updateUserProfile(
        context: context,
        ref: ref,
        id: user.id,
        fullName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        address: newAddress,
        image: user.image ?? '',
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin cá nhân", style: AppStyles.STYLE_18_BOLD),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blackFont,
        elevation: 1,
      ),
      backgroundColor: AppColors.white40,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Ảnh đại diện
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ảnh đại diện", style: AppStyles.STYLE_14_BOLD),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: _buildImage(widget.image ?? ''),

                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Họ tên
                Text("Họ tên", style: AppStyles.STYLE_14_BOLD),
                const SizedBox(height: 6),
                TextFormField(
                  controller: nameController,
                  style: AppStyles.STYLE_14,
                  validator: _requiredValidator,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 12),

                /// Số điện thoại
                Text("Số điện thoại", style: AppStyles.STYLE_14_BOLD),
                const SizedBox(height: 6),
                TextFormField(
                  controller: phoneController,
                  style: AppStyles.STYLE_14,
                  validator: _requiredValidator,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 12),

                /// Email
                Text("Email", style: AppStyles.STYLE_14_BOLD),
                const SizedBox(height: 6),
                TextFormField(
                  controller: emailController,
                  style: AppStyles.STYLE_14,
                  validator: _requiredValidator,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 12),

                /// Địa chỉ
                Text("Địa chỉ", style: AppStyles.STYLE_14_BOLD),
                const SizedBox(height: 6),
                TextFormField(
                  controller: addressController,
                  style: AppStyles.STYLE_14,
                  validator: _requiredValidator,
                  decoration: _inputDecoration(hintText: "Chưa có dữ liệu"),
                ),
                const SizedBox(height: 20),

                /// Nút lưu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateUserProfile();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Lưu thay đổi"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider _buildImage(String imagePath) {
    if (imagePath.isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Không được để trống';
    }
    return null;
  }
}
