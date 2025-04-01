import 'package:admin_panel_app_web/controllers/order_controller.dart';
import 'package:admin_panel_app_web/models/order.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetStates();
}

class _OrderWidgetStates extends State<OrderWidget> {
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderController().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Không có đơn hàng"));
        } else {
          final orders = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () {
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Ảnh sản phẩm
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: order.image.isNotEmpty
                                  ? Image.network(
                                order.image,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              )
                                  : const Icon(Icons.image_not_supported, size: 80),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Sản phẩm
                          Expanded(
                            flex: 3,
                            child: Text(
                              order.productName,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Giá sản phẩm
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${order.productPrice} VND",
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ),

                          // Danh mục hàng
                          Expanded(
                            flex: 2,
                            child: Text(
                              order.category,
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ),

                          // Người mua
                          Expanded(
                            flex: 2,
                            child: Text(
                              order.fullName,
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ),

                          // Email
                          Expanded(
                            flex: 2,
                            child: Text(
                              order.email,
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ),

                          // Địa chỉ
                          Expanded(
                            flex: 2,
                            child: Text(
                              order.address,
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ),

                          // Trạng thái
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  order.processing ? Icons.hourglass_top : Icons.check,
                                  color: order.processing ? Colors.orange : Colors.green,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  order.processing ? "Đang xử lý" : "Đã giao hàng",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: order.processing ? Colors.orange : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
