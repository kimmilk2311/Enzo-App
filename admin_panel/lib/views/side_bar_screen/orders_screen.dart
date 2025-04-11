import 'package:admin_panel_app_web/views/side_bar_screen/widgets/buyer_widget.dart';
import 'package:admin_panel_app_web/views/side_bar_screen/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatelessWidget {
  static const String id = 'orderscreen';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget rowHeader(int flex, String text) {
      return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: const Color(
              0xFF3C55EF,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Quản lý đơn hàng',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              rowHeader(2, 'Ảnh sản phẩm'),
              rowHeader(3, 'Sản phẩm'),
              rowHeader(2, 'Giá'),
              rowHeader(2, 'Danh mục hàng'),
              rowHeader(2, 'Người mua'),
              rowHeader(2, 'Email '),
              rowHeader(2, 'Địa chỉ'),
              rowHeader(2, 'Trạng thái'),
            ],
          ),
      const    OrderWidget(),
        ],
      ),
    );
  }
}
