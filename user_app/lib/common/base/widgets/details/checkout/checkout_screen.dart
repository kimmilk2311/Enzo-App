import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_store/common/base/widgets/common/app_button.dart';
import 'package:multi_store/common/base/widgets/common/custom_app_bar.dart';
import 'package:multi_store/common/base/widgets/common/my_profile_widget.dart';
import 'package:multi_store/controller/order_controller.dart';
import 'package:multi_store/provider/cart_provider.dart';
import 'package:multi_store/provider/user_provider.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/services/manage_http_response.dart';
import 'package:multi_store/ui/main/screen/main_page.dart';
import 'package:multi_store/ui/navigation/screens/home_page.dart';
import 'package:multi_store/ui/started/screen/payment_page.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'stripe';
  final OrderController _orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final userData = ref.watch(userProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final address = ref.read(userProvider)?.address ?? '';

    return Scaffold(
      appBar: const CustomAppBar(title: "Thanh toán"),
      backgroundColor: AppColors.white40,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Địa chỉ giao hàng
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.icPosition,
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userData?.fullName ?? "Chưa có tên",
                          style: AppStyles.STYLE_14_BOLD
                              .copyWith(color: AppColors.blackFont),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData?.phone ?? "Thêm số điện thoại",
                          style: AppStyles.STYLE_12
                              .copyWith(color: AppColors.blackFont),
                        ),
                        Text(
                          userData?.email ?? "Thêm Email",
                          style: AppStyles.STYLE_12
                              .copyWith(color: AppColors.greyTextField),
                        ),
                        Text(
                          userData?.address ?? "Thêm địa chỉ",
                          style: AppStyles.STYLE_12
                              .copyWith(color: AppColors.greyTextField),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyProfileWidget(
                            image: userData?.image ?? '',
                            fullName: userData?.fullName ?? '',
                            phone: userData?.phone ?? '',
                            email: userData?.email ?? '',
                            address: userData?.address ?? '',
                          ),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      AppImages.icEdit,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Sản phẩm",
              style:
                  AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.blackFont),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: cartData.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cartItem = cartData.values.toList()[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            cartItem.images[0],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.STYLE_16
                                    .copyWith(color: AppColors.blackFont),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cartItem.category,
                                style: AppStyles.STYLE_12
                                    .copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${cartItem.quantity} x ${cartItem.productPrice}đ",
                                style: AppStyles.STYLE_12_BOLD
                                    .copyWith(color: AppColors.bluePrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Phương thức thanh toán",
              style:
                  AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.blackFont),
            ),
            RadioListTile(
              title: Text(
                "Stripe",
                style: AppStyles.STYLE_14_BOLD
                    .copyWith(color: AppColors.blackFont),
              ),
              value: "stripe",
              groupValue: selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
                title: Text(
                  "Nhận hàng thanh toán",
                  style: AppStyles.STYLE_14_BOLD
                      .copyWith(color: AppColors.blackFont),
                ),
                value: 'cashOnDelivery',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                }),
            if (address.trim().isEmpty)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyProfileWidget(
                        image: userData?.image ?? '',
                        fullName: userData?.fullName ?? '',
                        phone: userData?.phone ?? '',
                        email: userData?.email ?? '',
                        address: userData?.address ?? '',
                      ),
                    ),
                  );
                },
                child: Text(
                  "Nhập địa chỉ giao hàng",
                  style: AppStyles.STYLE_16_BOLD.copyWith(
                    color: AppColors.blackFont,
                  ),
                ),
              )
            else
              AppButton(
                text:
                    selectedPaymentMethod == 'stripe' ? "Mua ngay" : "Đặt hàng",
                onPressed: () async {
                  if (selectedPaymentMethod == 'stripe') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PaymentPage(
                        amount: _cartProvider.getCartItems.values.fold(
                            0,
                            (sum, cart) =>
                                sum + cart.productPrice * cart.quantity),
                      );
                    })).then((value) async {
                      if (value is bool && value) {
                        await Future.forEach(_cartProvider.getCartItems.entries,
                            (entry) {
                          var item = entry.value;
                          _orderController.uploadOrders(
                            id: '',
                            fullName: ref.read(userProvider)!.fullName,
                            email: ref.read(userProvider)!.email,
                            address: ref.read(userProvider)!.address,
                            productName: item.productName,
                            productPrice: item.productPrice,
                            quantity: item.quantity,
                            category: item.category,
                            image: item.images[0],
                            phone: ref.read(userProvider)!.phone,
                            buyerId: ref.read(userProvider)!.id,
                            vendorId: item.vendorId,
                            processing: true,
                            delivered: false,
                            context: context,
                          );
                        }).then((value) {
                          _cartProvider.clearCart();
                          showSnackBar(context, "Đặt hàng thành công");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const MainPage();
                          }));
                        });
                      } else {
                        showSnackBar(context, "Đặt hàng thất bại");
                      }
                    });
                    // pay with stripe
                  } else {
                    await Future.forEach(_cartProvider.getCartItems.entries,
                        (entry) {
                      var item = entry.value;
                      _orderController.uploadOrders(
                        id: '',
                        fullName: ref.read(userProvider)!.fullName,
                        email: ref.read(userProvider)!.email,
                        address: ref.read(userProvider)!.address,
                        productName: item.productName,
                        productPrice: item.productPrice,
                        quantity: item.quantity,
                        category: item.category,
                        image: item.images[0],
                        phone: ref.read(userProvider)!.phone,
                        buyerId: ref.read(userProvider)!.id,
                        vendorId: item.vendorId,
                        processing: true,
                        delivered: false,
                        context: context,
                      );
                    }).then((value) {
                      _cartProvider.clearCart();
                      showSnackBar(context, "Đặt hàng thành công");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MainPage();
                      }));
                    });
                  }
                },
                color: AppColors.bluePrimary,
                textColor: AppColors.white,
              ),
          ],
        ),
      ),
    );
  }
}
