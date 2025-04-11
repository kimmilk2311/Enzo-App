import 'dart:convert';

import 'package:multi_store/data/model/order.model.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store/services/manage_http_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';

class OrderController {
  uploadOrders({
    required String id,
    required String fullName,
    required String email,
    required String address,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String phone,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required context,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token') ?? '';
      final Order order = Order(
        id: id,
        fullName: fullName,
        email: email,
        address: address,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        phone: phone,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/orders"),
        body: order.toJson(),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Đặt hàng thành công");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // lay don dat hang boi buyerId
  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token') ?? '';
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/$buyerId'),
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders = data.map((order) => Order.fromJson(order)).toList();
        return orders;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Không tải được đơn đặt hàng");
      }
    } catch (e) {
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

  // so don hang hoan tat
  Future<int> getDeliveredOrdersCount({required String buyerId}) async {
    try {
      List<Order> orders = await loadOrders(buyerId: buyerId);

      int deliveredCount = orders.where((order) => order.delivered).length;
      return deliveredCount;
    } catch (e) {
      throw Exception("Lỗi tải đơn đặt hàng");
    }
  }
}
