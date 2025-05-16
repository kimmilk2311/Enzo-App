import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/details/products/product_item_widget.dart';
import 'package:multi_store/controller/product_controller.dart';
import 'package:multi_store/provider/product_provider.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/services/manage_http_response.dart';

import '../../../../../provider/all_product_provider.dart';

class AllProductWidget extends ConsumerStatefulWidget {
  const AllProductWidget({super.key});

  @override
  ConsumerState<AllProductWidget> createState() => _AllProductWidgetState();
}

class _AllProductWidgetState extends ConsumerState<AllProductWidget> {
  @override
  void initState() {
    super.initState();
    final products = ref.read(allProductProvider);
    if (products.isEmpty) {
      _fetchProduct();
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadAllProducts();
      ref.read(allProductProvider.notifier).setProducts(products);
    } catch (e) {
     showSnackBar(context, "Lỗi tải sản phẩm: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductProvider);
    return SizedBox(
      height: 250,
      child: products.isEmpty && !ref.watch(allProductProvider.notifier).mounted
          ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
          : products.isEmpty
          ? const Center(child: Text("Không có sản phẩm"))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItemWidget(product: product);
        },
      ),
    );
  }
}