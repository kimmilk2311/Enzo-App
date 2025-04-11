import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../global_variables.dart';
import '../provider/vendor_provider.dart';
import '../services/manage_http_response.dart';
import '../views/screens/authentication/login_page.dart';
import '../views/screens/authentication/main_vendor_page.dart';

class VendorAuthController {

  // ✅ Đăng ký Vendor
  Future<void> signUpVendor({
    required BuildContext context,
    required String email,
    required String phone,
    required String fullName,
    required String password,
    String image = '',
    String address = '',
  }) async {
    try {
      final requestBody = jsonEncode({
        "email": email,
        "phone": phone,
        "fullName": fullName,
        "password": password,
        "image": image,
        "address": address,
      });

      final response = await http.post(
        Uri.parse('$uri/api/vendor/signup'),
        body: requestBody,
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          showSnackBar(context, "Đăng ký thành công");
        },
      );
    } catch (e) {
      showSnackBar(context, "Lỗi khi đăng ký: $e");
    }
  }

  // ✅ Đăng nhập Vendor
  Future<void> signInVendor({
    required BuildContext context,
    required String loginInput,
      required String password,
      required WidgetRef ref, // ✅ Thêm tham số này để cập nhật Provider
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$uri/api/vendor/signin"),
        body: jsonEncode({"loginInput": loginInput, "password": password}),
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final data = jsonDecode(response.body);
          final String token = data['token'];
          final vendorData = data['vendor'];
          final String vendorId = vendorData['id'] ?? vendorData['_id']; // ✅ Lấy đúng `vendorId`

          SharedPreferences prefs = await SharedPreferences.getInstance();

          // ✅ Xóa toàn bộ dữ liệu cũ trước khi lưu dữ liệu mới
          await prefs.remove('auth_token');
          await prefs.remove('vendor');
          await prefs.remove('vendorId');

          // ✅ Lưu dữ liệu mới
          await prefs.setString('auth_token', token);
          await prefs.setString('vendor', jsonEncode(vendorData));
          await prefs.setString('vendorId', vendorId);

          // ✅ Cập nhật Provider với dữ liệu mới
          ref.read(vendorProvider.notifier).setVendor(jsonEncode(vendorData));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainVendorPage()),
                (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, "Lỗi khi đăng nhập: $e");
    }
  }


  // ✅ Đăng xuất Vendor
  Future<void> signOutVendor({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('vendor');
      await prefs.remove('vendorId'); // 🔑 Xóa vendorId khi đăng xuất

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );

      showSnackBar(context, "Đăng xuất thành công");
    } catch (e) {
      showSnackBar(context, "Lỗi khi đăng xuất");
    }
  }
}
