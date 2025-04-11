import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vendor_store/resource/theme/app_colors.dart';
import 'package:vendor_store/resource/theme/app_styles.dart';

import '../../../controllers/order_controller.dart';
import '../../../provider/order_provider.dart';
import '../../../provider/total_earnings_provider.dart';
import '../../../provider/vendor_provider.dart';

class EarningsPage extends ConsumerStatefulWidget {
  const EarningsPage({super.key});

  @override
  ConsumerState<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends ConsumerState<EarningsPage> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final vendor = ref.read(vendorProvider);
    if (vendor != null) {
      final OrderController orderController = OrderController();
      try {
        final orders = await orderController.loadOrders(vendorId: vendor.id);
        ref.read(orderProvider.notifier).setOrders(orders);
        ref.read(totalEarningsProvider.notifier).calculateEarnings(orders);
      } catch (e) {
        print("Lỗi đơn hàng: $e");
      }
    }
  }

  String formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(totalEarningsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bluePrimary,
        elevation: 0,
        title: Text(
          vendor != null ? "Chào, ${vendor.fullName}" : "Đang tải...",
          style: AppStyles.STYLE_20_BOLD.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: vendor == null
          ? const Center(
        child: Text(
          "Không tìm thấy dữ liệu vendor. Vui lòng đăng nhập lại.",
          style: TextStyle(color: Colors.red),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thẻ thông tin tài khoản
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: vendor.image.isNotEmpty
                        ? NetworkImage(vendor.image)
                        : null,
                    backgroundColor: AppColors.grey,
                    child: vendor.image.isEmpty
                        ? Text(
                      vendor.fullName.isNotEmpty
                          ? vendor.fullName[0].toUpperCase()
                          : "?",
                      style: AppStyles.STYLE_28_BOLD
                          .copyWith(color: AppColors.white),
                    )
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    vendor.fullName,
                    style: AppStyles.STYLE_20_BOLD,
                  ),
                  Text(
                    vendor.email,
                    style: AppStyles.STYLE_14.copyWith(
                      color: AppColors.greyDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Thẻ thống kê
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Thống Kê Doanh Thu",
                    style: AppStyles.STYLE_18_BOLD.copyWith(
                      color: AppColors.bluePrimary,
                    ),
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(height: 20),
                  Text(
                    "Tổng đơn hàng",
                    style: AppStyles.STYLE_16.copyWith(color: AppColors.blackFont),
                  ),
                  Text(
                    totalEarnings['totalOrders']?.toString() ?? "0",
                    style: AppStyles.STYLE_28_BOLD.copyWith(
                      color: AppColors.bluePrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Tổng doanh thu",
                    style: AppStyles.STYLE_16.copyWith(color: AppColors.blackFont),
                  ),
                  Text(
                    formatCurrency(totalEarnings['totalEarnings'] ?? 0),
                    style: AppStyles.STYLE_28_BOLD.copyWith(
                      color: AppColors.green600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
