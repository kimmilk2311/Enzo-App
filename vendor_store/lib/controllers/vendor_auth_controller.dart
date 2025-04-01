import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_store/models/vendor.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/services/manage_http_response.dart';
import 'package:vendor_store/views/screens/authentication/main_vendor_page.dart';

import '../global_variables.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  // Ham xu ly dang ky vendor
  Future<void> signUpVendor({
    required String fullName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      Vendor vendor = Vendor(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/vendor/signup"),
        body: vendor.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      // Xu ly phan hoi tu server
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Tạo tài khoản thành công");
        },
      );
    } catch (e) {
      showSnackBar(context, "Lỗi đăng ký: $e");
    }
  }

  // Ham xu ly dang nhap vendor
  Future<void> signInVendor({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/vendor/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );


      // Xu ly phan hoi tu server
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();

          // Lay token tu phan hoi cua server, kiem tra truoc khi su dung
          var responseBody = jsonDecode(response.body);
          if (responseBody['token'] == null || responseBody['vendor'] == null) {
            showSnackBar(context, "Dữ liệu phản hồi từ máy chủ không hợp lệ");
            return;
          }

          String token = responseBody['token'];
          final vendorData = responseBody['vendor'];

          // Luu token vao SharedPreferences
          await preferences.setString('auth_token', token);

          // Chuyen doi vendorData thanh JSON an toan
          final vendorJson = jsonEncode(vendorData);
          await preferences.setString('vendor', vendorJson);


          // Cap nhat trang thai ung dung voi du lieu vendor su dung Riverpod
          providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);

          // Dieu huong den trang chinh sau khi dang nhap thanh cong
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainVendorPage()),
                (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, "Lỗi đăng nhập: $e");
    }
  }
}
