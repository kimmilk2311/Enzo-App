import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store/provider/delivered_order_count_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global_variables.dart';
import '../provider/user_provider.dart';
import '../services/manage_http_response.dart';
import '../ui/authentication/login/screen/login_page.dart';
import '../ui/main/screen/main_page.dart';

class AuthController {
  // ✅ 1. Cập nhật thông tin user
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

      final response = await http.put(
        Uri.parse('$uri/api/user/update/$id'),
        body: jsonEncode(updatedData),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final userJson = jsonEncode(jsonDecode(response.body)['user']);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', userJson);
          ref.read(userProvider.notifier).setUser(userJson);
          if (!context.mounted) return;
          showSnackBar(context, "Đã cập nhật thông tin thành công");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Lỗi khi cập nhật: ${e.toString()}");
      }
    }
  }

  // ✅ 2. Đăng ký người dùng
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
      final requestBody = {
        "email": email,
        "phone": phone,
        "fullName": fullName,
        "password": password,
        "image": image,
        "address": address,
      };

      final response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
          showSnackBar(context, "Tài khoản đã được tạo");
        },
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Đã xảy ra lỗi khi đăng ký");
      }
    }
  }

  // ✅ 3. Đăng nhập người dùng
  Future<void> signInUsers({
    required BuildContext context,
    required String loginInput,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({'loginInput': loginInput, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final data = jsonDecode(response.body);
          final String token = data['token'];
          final userMap = data['user'] as Map<String, dynamic>;
          userMap['token'] = token;

          final userJson = jsonEncode(userMap);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user', userJson);

          ref.read(userProvider.notifier).setUser(userJson);

          if (!context.mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
                (route) => false,
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Đã xảy ra lỗi khi đăng nhập");
      }
    }
  }

  // ✅ 4. Đăng xuất người dùng
  Future<void> signOutUser({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user');

      ref.read(userProvider.notifier).signOut();
      ref.read(deliveredOrderCountProvider.notifier).resetCount();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );

      showSnackBar(context, "Đăng xuất thành công");
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Lỗi khi đăng xuất");
      }
    }
  }

  // ✅ 5. Cập nhật địa chỉ người dùng
  Future<void> updateUserLocation({
    required BuildContext context,
    required String id,
    required String address,
    required WidgetRef ref,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$uri/api/user/update/$id'),
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
        body: jsonEncode({'address': address}),
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final updatedUser = jsonDecode(response.body);
          final prefs = await SharedPreferences.getInstance();
          final userJson = jsonEncode(updatedUser);
          ref.read(userProvider.notifier).setUser(userJson);
          await prefs.setString('user', userJson);
        },
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Lỗi cập nhật địa chỉ");
      }
    }
  }
}
