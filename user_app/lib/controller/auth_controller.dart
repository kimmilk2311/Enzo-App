import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/user_model.dart';
import '../global_variables.dart';
import '../provider/user_provider.dart';
import '../services/manage_http_response.dart';
import '../ui/main/screen/main_page.dart';
import '../ui/authentication/login/screen/login_page.dart';

final providerContainer = ProviderContainer();

class AuthController {
  // ✅ Cập nhật thông tin user
  Future<void> updateUserProfile({
    required BuildContext context,
    required WidgetRef ref,
    required String id,
    required String fullName,
    required String phone,
    required String email,
    required String address,
    String image = '',
  }) async {
    try {
      final updatedData = {
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'address': address,
        'image': image,
      };

      http.Response response = await http.put(
        Uri.parse('$uri/api/user/update/$id'),
        body: jsonEncode(updatedData),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final userJson = jsonEncode(jsonDecode(response.body)['user']);

          // ✅ Lưu vào local
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', userJson);

          // ✅ Cập nhật provider
          ref.read(userProvider.notifier).setUser(userJson);

          showSnackBar(context, "Đã cập nhật thông tin thành công");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, "Lỗi khi cập nhật: ${e.toString()}");
    }
  }

  Future<void> signUpUsers({
    required BuildContext context,
    required String email,
    required String phone,
    required String fullName,
    required String password,
    String image = '',
    String address = '',
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "email": email,
        "phone": phone,
        "fullName": fullName,
        "password": password,
        "image": image,
        "address": address,
      };

      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: jsonEncode(requestBody),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          showSnackBar(context, "Tài khoản đã được tạo");
        },
      );
    } catch (e) {
      print("Error in signUpUsers: $e");
      showSnackBar(context, "Đã xảy ra lỗi khi đăng ký");
    }
  }

  Future<void> signInUsers({
    required BuildContext context,
    required String loginInput,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({
          'loginInput': loginInput,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final SharedPreferences preferences = await SharedPreferences.getInstance();

          final data = jsonDecode(response.body);
          final String token = data['token'];
          final userMap = data['user'] as Map<String, dynamic>;
          userMap['token'] = token;

          final String userJson = jsonEncode(userMap);

          providerContainer.read(userProvider.notifier).setUser(userJson);
          await preferences.setString('auth_token', token);
          await preferences.setString('user', userJson);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      print("Error in signInUsers: $e");
      showSnackBar(context, "Đã xảy ra lỗi khi đăng nhập");
    }
  }

  Future<void> signOutUser({required BuildContext context}) async {
    try {
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('auth_token');
      await preferences.remove('user');

      providerContainer.read(userProvider.notifier).signOut();

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

  // cap nhat trang thai nguoi dung
  Future<void> updateUserLocation({
    required context,
    required String id,
    required String address,
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse('$uri/api/user/update/$id'),
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'address': address,
        }),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
       final updatedUser =  jsonDecode(response.body);
       SharedPreferences preferences = await SharedPreferences.getInstance();
       final userJson = jsonEncode(updatedUser);
       providerContainer.read(userProvider.notifier).setUser(userJson);
       await preferences.setString('user', userJson);
        },
      );
    } catch (e) {
      showSnackBar(context, "Lỗi cập nhật địa chỉ");
    }
  }
}
