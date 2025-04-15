  import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/common/base/widgets/common/confirm_dialog.dart';
import 'package:multi_store/common/base/widgets/details/checkout/checkout_screen.dart';
import 'package:multi_store/provider/cart_provider.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

import '../../../common/base/widgets/common/custom_app_bar.dart';
import '../../../resource/asset/app_images.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  String formatCurrency(double price) {
    final format = NumberFormat.currency(symbol: 'đ', locale: 'vi_VN');
    return format.format(price);
  }

  // ✅ Hàm hiển thị hộp thoại xác nhận xoá sản phẩm
  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        content: "Xóa sản phẩm này khỏi giỏ hàng?",
        onConfirm: () {
          ref.read(cartProvider.notifier).removeCartItem(productId);
        },
        onCancel: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartProvider.notifier).calculateTotalAmount();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Giỏ hàng",
          style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColors.blackFont),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(AppImages.icCart),
              ),
              if (cartData.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartData.length.toString(),
                      style: AppStyles.STYLE_12_BOLD.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: cartData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Giỏ hàng trống",
                    style:
                        AppStyles.STYLE_16.copyWith(color: AppColors.blackFont),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: cartData.length,
                itemBuilder: (context, index) {
                  final cartItem = cartData.values.toList()[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Ảnh sản phẩm với nút delete
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cartItem.images[0],
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: -4,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _showDeleteConfirmationDialog(
                                        context, cartItem.productId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.white40,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.delete,
                                        size: 14, color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),

                          // Thông tin sản phẩm
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.productName,
                                  style: AppStyles.STYLE_14_BOLD
                                      .copyWith(color: AppColors.blackFont),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cartItem.category,
                                  style: AppStyles.STYLE_12
                                      .copyWith(color: AppColors.greyTextField),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatCurrency(
                                      cartItem.productPrice.toDouble()),
                                  style: AppStyles.STYLE_12_BOLD
                                      .copyWith(color: AppColors.bluePrimary),
                                ),
                              ],
                            ),
                          ),

                          // ✅ Điều chỉnh số lượng
                          SizedBox(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (cartItem.quantity > 1) {
                                      ref
                                          .read(cartProvider.notifier)
                                          .decrementCartItem(
                                              cartItem.productId);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.cinder100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.remove,
                                        size: 14, color: AppColors.bluePrimary),
                                  ),
                                ),
                                Text(
                                  cartItem.quantity.toString(),
                                  style: AppStyles.STYLE_12_BOLD,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .incrementCartItem(cartItem.productId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.cinder100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.add,
                                        size: 14, color: AppColors.bluePrimary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: cartData.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Tổng thanh toán",
                          style: AppStyles.STYLE_14_BOLD
                              .copyWith(color: AppColors.blackFont),
                        ),
                        Text(
                          formatCurrency(totalAmount),
                          style: AppStyles.STYLE_14_BOLD
                              .copyWith(color: AppColors.bluePrimary),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    child: AppButton(
                      text: "Mua hàng (${cartData.length})",
                      onPressed: () {
                        if (totalAmount == 0.0) return;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ));
                      },
                      color: totalAmount == 0.0
                          ? AppColors.grey
                          : AppColors.bluePrimary,
                      textColor: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
