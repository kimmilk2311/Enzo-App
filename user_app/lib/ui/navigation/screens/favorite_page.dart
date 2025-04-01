import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:multi_store/common/base/widgets/common/confirm_dialog.dart';
import 'package:multi_store/provider/favorite_provider.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

class FavoritePage extends ConsumerStatefulWidget {
  const FavoritePage({super.key});

  @override
  ConsumerState<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  String formatCurrency(double price) {
    final format = NumberFormat.currency(symbol: 'đ', locale: 'vi_VN');
    return format.format(price);
  }

  // Hàm xác nhận xoá sản phẩm khỏi danh sách yêu thích
  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        content: "Xóa sản phẩm này khỏi danh sách yêu thích?",
        onConfirm: () {
          ref.read(favoriteProvider.notifier).removeFavoriteItem(productId);
        },
        onCancel: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishItemData = ref.watch(favoriteProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Danh sách yêu thích",
          style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColors.blackFont),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(AppImages.icCart),
              ),
              if (wishItemData.isNotEmpty)
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
                      wishItemData.length.toString(),
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
      body: wishItemData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Danh sách yêu thích trống",
                    style:
                        AppStyles.STYLE_16.copyWith(color: AppColors.blackFont),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: wishItemData.length,
              itemBuilder: (context, index) {
                final wishData = wishItemData.values.toList()[index];

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Container(
                      width: 335,
                      height: 96,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 336,
                              height: 97,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFFEFF0F2),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 13,
                            top: 9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 78,
                                height: 78,
                                child: Image.network(
                                  wishData.images[0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 101,
                            top: 14,
                            child: SizedBox(
                              width: 162,
                              child: Text(
                                wishData.productName,
                                style: AppStyles.STYLE_14_BOLD
                                    .copyWith(color: AppColors.blackFont),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 101,
                            top: 35,
                            child: Text(
                              wishData.category,
                              style: AppStyles.STYLE_12
                                  .copyWith(color: AppColors.greyTextField),
                            ),
                          ),
                          Positioned(
                            right: 15,
                            top: 16,
                            child: Text(
                              formatCurrency(wishData.productPrice.toDouble()),
                              style: AppStyles.STYLE_12_BOLD
                                  .copyWith(color: AppColors.bluePrimary),
                            ),
                          ),
                          Positioned(
                            left: 284,
                            top: 47,
                            child: IconButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, wishData.productId);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
