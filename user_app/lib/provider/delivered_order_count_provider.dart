import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/order_controller.dart';
import '../services/manage_http_response.dart';

class DeliveredOrderCountProvider extends StateNotifier<int> {
  DeliveredOrderCountProvider() : super(0);

  Future<void> fetchDeliveredOrdersCount(String buyerId, BuildContext context) async {
    try {
      OrderController orderController = OrderController();
      int count = await orderController.getDeliveredOrdersCount(buyerId: buyerId);
      state = count;
    } catch (e) {
      showSnackBar(context, "Lỗi tải đơn đặt hàng $e");
    }
  }
  void resetCount() {
    state = 0;
  }
}

final deliveredOrderCountProvider = StateNotifierProvider<DeliveredOrderCountProvider, int>((ref) {
  return DeliveredOrderCountProvider();
});

