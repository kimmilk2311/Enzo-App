import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store/provider/cart_provider.dart';
import 'package:multi_store/provider/delivered_order_count_provider.dart';
import 'package:multi_store/provider/favorite_provider.dart';
import 'package:multi_store/ui/authentication/verify/otp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global_variables.dart';
import '../provider/user_provider.dart';
import '../services/manage_http_response.dart';
import '../ui/authentication/login/screen/login_page.dart';
import '../ui/main/screen/main_page.dart';

class AuthController {
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
            MaterialPageRoute(builder: (context) => OtpPage(email: email)),
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
          final prefs = await SharedPreferences.getInstance();

          String token = jsonDecode(response.body)['token'];

          await prefs.setString('auth_token', token);

          final userJson = jsonEncode(jsonDecode(response.body) );

          ref.read(userProvider.notifier).setUser(response.body);

          await prefs.setString('user', userJson);

          ref.read(deliveredOrderCountProvider.notifier).resetCount();
          ref.read(favoriteProvider.notifier).resetFavorites();
          ref.read(cartProvider.notifier).clearCart();

          if(ref.read(userProvider)!.token.isNotEmpty){

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
            );
            showSnackBar(context, "Đăng nhập thành công");
          }
        },
      );
    } catch (e) {
        showSnackBar(context, "Đã xảy ra lỗi khi đăng nhập");

    }
  }

  getUserData(context, WidgetRef ref) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String? token = preferences.getString('auth_token');

      if (token == null) {
        preferences.setString('auth_token', '');
      }

      var tokenResponse = await http.post(
        Uri.parse('$uri/api/tokenIsValid'),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      var response = jsonDecode(tokenResponse.body);
      if (response == true) {
        http.Response userResponse = await http.get(
          Uri.parse('$uri/'),
          headers: {
            "Content-Type": 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        ref.read(userProvider.notifier).setUser(userResponse.body);

      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

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
      ref.read(favoriteProvider.notifier).resetFavorites();
      ref.read(cartProvider.notifier).clearCart();

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

  // xac thuc tai khoan
  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/verify-otp'),
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
        headers: <String, String>{"Content-Type": 'application/json; charset=UTF-8'},
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              return const LoginPage();
            }), (route) => false);
            showSnackBar(context, "Xác thực thành công. Đăng nhập ngay");
          });
    } catch (e) {
      showSnackBar(context, "Lỗi xac thực OTP: $e");
    }
  }

  Future<void> deleteAccount({
    required BuildContext context,
    required String id,
    required WidgetRef ref,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');

      if (token == null) {
        if (!context.mounted) return;
        showSnackBar(context, "Vui lòng đăng nhập lại");
        return;
      }

      http.Response response = await http.delete(
        Uri.parse("$uri/api/user/delete-account/$id"),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          await preferences.remove('auth_token');

          await preferences.remove('user');

          ref.read(userProvider.notifier).signOut();
          ref.read(deliveredOrderCountProvider.notifier).resetCount();
          ref.read(favoriteProvider.notifier).resetFavorites();
          ref.read(cartProvider.notifier).clearCart();

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return const LoginPage();
          }));

          showSnackBar(context, "Tài khoản đã được xóa");
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, "Lỗi xóa tài khoản: $e");
    }
  }
}
