import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_store/controllers/vendor_auth_controller.dart';
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/views/screens/authentication/login_page.dart'; // Import trang đăng nhập

class SignOutButton extends ConsumerWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Xóa token và dữ liệu người dùng khỏi SharedPreferences
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('auth_token');
        await preferences.remove('vendor');

        // Đặt trạng thái vendorProvider về null
        ref.read(vendorProvider.notifier).signOut();

        // Điều hướng về trang đăng nhập (hoặc trang chủ, tùy thuộc vào logic của bạn)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()), // Thay LoginPage bằng trang bạn muốn
              (route) => false, // Xóa tất cả các route trước đó khỏi stack
        );
      },
      child: const Text('Sign Out'),
    );
  }
}