import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';
import '../models/order.dart';
import '../services/manage_http_response.dart';

class OrderController {
  // lay don dat hang boi vendorId
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token') ?? '';


      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/$vendorId'),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders = data.map((order) => Order.fromJson(order)).toList();
        return orders;
      } else {
        print('Lỗi từ server: ${response.body}');
        throw Exception("Không tải được đơn đặt hàng");
      }
    } catch (e) {
      print('Lỗi tải đơn đặt hàng: $e');
      throw Exception("Lỗi tải đơn đặt hàng");
    }
  }

  // Xoa don hang
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token') ?? '';
      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Xóa đơn hàng thành công");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateOrderStatus({required String id, required context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse("$uri/api/orders/$id/delivered"),
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "delivered": true,
          "processing": false,
        }),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Giao hàng thành công");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> cancelOrder({required String id, required context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse("$uri/api/orders/$id/processing"),
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "processing": false,
          "delivered": false,
        }),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, " Hủy đơn hàng thành công  ");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
