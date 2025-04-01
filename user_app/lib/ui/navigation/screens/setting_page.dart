import 'dart:io';
import 'package:flutter/material.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/common/base/widgets/common/my_profile_widget.dart';
import 'package:multi_store/common/base/widgets/common/reusable_text_widget.dart';
import 'package:multi_store/common/base/widgets/details/order/order_screen.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/controller/auth_controller.dart';
import 'package:multi_store/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  final AuthController _authController = AuthController();

  Future<void> _signOutUser(BuildContext context) async {
    await _authController.signOutUser(context: context);
  }

  ImageProvider _buildUserImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.white40,
      appBar: AppBar(
        backgroundColor: AppColors.white40,
        elevation: 0,
        title: Text(
          "Tài khoản",
          style: AppStyles.STYLE_26_BOLD.copyWith(color: AppColors.blackFont),
        ),
        centerTitle: false,
      ),


      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// 🔹 Hình đại diện
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: _buildUserImage(user?.image),
                  ),
                  const SizedBox(width: 12),

                  /// 🔹 Thông tin và nút chỉnh sửa
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? "Tên người dùng",
                          style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.phone ?? "Số điện thoại",
                          style: AppStyles.STYLE_12.copyWith(color: AppColors.greyTextField),
                        ),
                      ],
                    ),
                  ),

                  /// 🔹 Icon setting
                  IconButton(
                    icon: const Icon(Icons.settings, color: AppColors.blackFont),
                    onPressed: () {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyProfileWidget(
                              image: user.image,
                              fullName: user.fullName,
                              phone: user.phone,
                              email: user.email,
                              address: user.address,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),


            const Divider(height: 1, thickness: 0.5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bluePrimary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await _signOutUser(context);
                },
                child: const Text("Đăng xuất"),
              ),
            ),
            AppButton(text: "Đơn hàng của tôi", onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return  OrderScreen();
              }));
            }),
          ],
        ),
      ),
    );
  }
}