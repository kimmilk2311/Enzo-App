import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store/resource/theme/app_colors.dart';

void manageHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  // ĐOẠN DEBUG THÊM VÀO
  print('=========== DEBUG SERVER RESPONSE ===========');
  print('Status Code: ${response.statusCode}');
  print('Raw Body: ${response.body}');
  try {
    final decoded = json.decode(response.body);
    print('Decoded JSON: $decoded');
  } catch (e) {
    print('Lỗi decode JSON: $e');
  }
  print('=============================================');

  // XỬ LÝ RESPONSE NHƯ CŨ
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;

    case 400:
      try {
        final responseBody = json.decode(response.body);
        if (responseBody is Map && (responseBody.containsKey('error') || responseBody.containsKey('message'))) {
          showSnackBar(
            context,
            responseBody['error']?.toString() ?? responseBody['message']?.toString() ?? 'Yêu cầu không hợp lệ (400).',
          );
        } else {
          showSnackBar(context, response.body.isNotEmpty ? response.body : 'Yêu cầu không hợp lệ (400).');
        }
      } catch (e) {
        print("Lỗi giải mã JSON (400): $e");
        showSnackBar(context, response.body.isNotEmpty ? response.body : 'Lỗi không xác định (400).');
      }
      break;

    case 404:
      try {
        final responseBody = json.decode(response.body);
        if (responseBody is Map && responseBody.containsKey('message')) {
          showSnackBar(context, responseBody['message']?.toString() ?? 'Không tìm thấy tài nguyên.');
        } else {
          showSnackBar(context, response.body.isNotEmpty ? response.body : 'Không tìm thấy (404).');
        }
      } catch (e) {
        print("Lỗi giải mã JSON (404): $e");
        showSnackBar(context, response.body.isNotEmpty ? response.body : 'Lỗi không tìm thấy không xác định (404).');
      }
      break;

    case 500:
      try {
        final responseBody = json.decode(response.body);
        if (responseBody is Map && responseBody.containsKey('error')) {
          showSnackBar(context, responseBody['error']?.toString() ?? 'Lỗi máy chủ không xác định.');
        } else {
          showSnackBar(context, response.body.isNotEmpty ? response.body : 'Lỗi máy chủ (500).');
        }
      } catch (e) {
        print("Lỗi giải mã JSON (500): $e");
        showSnackBar(context, response.body.isNotEmpty ? response.body : 'Lỗi máy chủ không xác định (500).');
      }
      break;

    default:
      String errorMessage = 'Đã xảy ra lỗi không mong muốn';
      try {
        final responseBody = json.decode(response.body);
        if (responseBody is Map) {
          errorMessage = responseBody['error']?.toString() ??
              responseBody['message']?.toString() ??
              'Lỗi không xác định từ máy chủ.';
        } else if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      } catch (_) {
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        } else {
          errorMessage = 'Lỗi HTTP ${response.statusCode}';
        }
      }
      showSnackBar(context, errorMessage);
  }
}



void showSnackBar(BuildContext context, String title) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        margin: const EdgeInsets.all(15),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.bluePrimary,
        content: Text(title)));
  }
}