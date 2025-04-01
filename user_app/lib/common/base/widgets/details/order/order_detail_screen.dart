import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_store/controller/product_review_controller.dart';
import 'package:multi_store/data/model/order.model.dart';
import 'package:multi_store/data/model/product_review.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

import '../../common/confirm_dialog.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

 const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();

  final ProductReviewController _productReviewController = ProductReviewController();

  double rating = 0.0;

  String formatCurrency(int price) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return format.format(price);
  }

  void _showDeleteConfirmationDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        content: "Bạn có chắc muốn xóa đơn hàng này?",
        onConfirm: () {
          print("Xoá đơn hàng ID: $orderId");
          Navigator.of(context).pop();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void clearReview(){
    _reviewController.clear();
    setState(() {
      rating= 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.order.productName,
          style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.white),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: AppColors.gold50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.order.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.productName,
                              style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.order.category,
                              style: AppStyles.STYLE_12.copyWith(color: AppColors.blackFont),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency(widget.order.productPrice),
                              style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.order.delivered
                                    ? AppColors.bluePrimary
                                    : widget.order.processing
                                        ? AppColors.cinder500
                                        : AppColors.gold600,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.order.delivered
                                    ? "Đã giao hàng"
                                    : widget.order.processing
                                        ? "Đang xử lý"
                                        : "Đã hủy",
                                style: AppStyles.STYLE_12_BOLD.copyWith(color: AppColors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 80,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.pink),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, widget.order.id);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              width: 336,
              height: widget.order.delivered == true ? 170 : 120,
              decoration: BoxDecoration(
                color: AppColors.white40,
                border: Border.all(color: AppColors.white),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Địa chỉ giao hàng",
                          style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.blackFont),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          " ${widget.order.address}",
                          style: AppStyles.STYLE_14.copyWith(color: AppColors.blackFont),
                        ),
                        Text(
                          "Từ: ${widget.order.fullName}",
                          style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
                        ),
                        Text(
                          "Mã đơn: ${widget.order.id}",
                          style: AppStyles.STYLE_12_BOLD.copyWith(color: AppColors.blackFont),
                        ),
                      ],
                    ),
                  ),
                  widget.order.delivered == true
                      ? ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Để lại đánh giá"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Đánh giá của bạn",
                                          ),
                                          controller: _reviewController,
                                        ),
                                        RatingBar(
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          onRatingChanged: (value){
                                            rating = value;
                                          },
                                          initialRating: 0,
                                          maxRating: 5,
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          final review = _reviewController.text;

                                          _productReviewController.uploadReview(
                                            buyerId: widget.order.buyerId,
                                            fullName: widget.order.fullName,
                                            email: widget.order.email,
                                            productId: widget.order.id,
                                            rating: rating,
                                            review: review,
                                            context: context,
                                          );
                                          clearReview();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Gửi đánh giá",
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Đánh giá",
                            style: AppStyles.STYLE_14.copyWith(color: AppColors.blackFont),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
