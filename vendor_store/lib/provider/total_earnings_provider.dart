import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store/models/order.dart';

class TotalEarningsProvider extends StateNotifier<Map<String, dynamic>> {
  TotalEarningsProvider() : super({'totalEarnings': 0.0, 'totalOrders': 0,});

  void calculateEarnings(List<Order> orders) {
    double earnings = 0.0;
    int orderCount = 0;

    for (Order order in orders) {
      if (order.delivered == true) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }
    state = {
      'totalEarnings': earnings,
      'totalOrders': orderCount,
    };
  }
}

final totalEarningsProvider = StateNotifierProvider<TotalEarningsProvider, Map<String, dynamic>>((ref){
  return TotalEarningsProvider();
});
