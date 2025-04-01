import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:multi_store/common/base/widgets/details/products/product_detail_screen.dart';
import 'package:multi_store/data/model/product.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

class ProductItemWidget extends ConsumerWidget {
  final Product product;

  const ProductItemWidget({super.key, required this.product});

  // Định dạng tiền tệ
  String formatCurrency(int price) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return format.format(price);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(product: product);
        }));
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Image.network(
                    product.images[0],
                    height: 170,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.productName,
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.blackFont),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              formatCurrency(product.productPrice),
              style: AppStyles.STYLE_12_BOLD
                  .copyWith(color: AppColors.bluePrimary),
            ),
            product.averageRating == 0
                ? SizedBox()
                : Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.averageRating.toStringAsFixed(1),
                        style: AppStyles.STYLE_12_BOLD
                            .copyWith(color: AppColors.blackFont),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
