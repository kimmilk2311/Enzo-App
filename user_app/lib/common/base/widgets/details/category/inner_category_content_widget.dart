import 'package:flutter/material.dart';
import 'package:multi_store/common/base/widgets/common/hearder_widget.dart';
import 'package:multi_store/common/base/widgets/common/reusable_text_widget.dart';
import 'package:multi_store/common/base/widgets/details/banner/inner_banner_widget.dart';
import 'package:multi_store/common/base/widgets/common/inner_header_widget.dart';
import 'package:multi_store/common/base/widgets/details/category/subcategory_tile_widget.dart';
import 'package:multi_store/controller/product_controller.dart';
import 'package:multi_store/data/model/subcategory_model.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

import '../../../../../controller/subcategory_controller.dart';
import '../../../../../data/model/category_model.dart';
import '../../../../../data/model/product.dart';
import '../products/product_item_widget.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final Category category;

  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() => _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState extends State<InnerCategoryContentWidget> {
  late Future<List<SubCategory>> _subcategories;
  late Future<List<Product>> futureProducts;
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState() {
    super.initState();
    _subcategories = _subcategoryController.getSubCategoriesByCategoryName(widget.category.name);
    futureProducts = ProductController().loadPopularProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const HeaderWidget(),
      ),
      backgroundColor: AppColors.white40,
      body: Column(
        children: [
          InnerBannerWidget(image: widget.category.banner),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "Danh mục sản phẩm",
              style: AppStyles.STYLE_20_BOLD.copyWith(
                color: AppColors.blackFont,
                letterSpacing: 1.7,
              ),
            ),
          ),
          FutureBuilder<List<SubCategory>>(
            future: _subcategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Không có danh mục phụ"),
                );
              } else {
                final subcategories = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: List.generate((subcategories.length / 7).ceil(), (setIndex) {
                      final start = setIndex * 7;
                      final end = (setIndex + 1) * 7;
                      return Padding(
                        padding: const EdgeInsets.all(8.9),
                        child: Row(
                          children: subcategories
                              .sublist(start, end > subcategories.length ? subcategories.length : end)
                              .map((subcategory) => SubcategoryTileWidget(
                                    image: subcategory.image,
                                    title: subcategory.subCategoryName,
                                  ))
                              .toList(),
                        ),
                      );
                    }),
                  ),
                );
              }
            },
          ),
          ReusableTextWidget(
            title: "Sản phẩm phổ biến",
            actionText: "Xem tất cả",
            onPressed: () {},
          ),
          FutureBuilder(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error ${snapshot.error}",
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Không có sản phẩm trong danh mục"),
                  );
                } else {
                  final products = snapshot.data;
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: products!.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItemWidget(
                          product: product,
                        );
                      },
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
