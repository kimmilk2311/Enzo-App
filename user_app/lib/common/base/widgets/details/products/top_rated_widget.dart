import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/details/products/product_item_widget.dart';
import 'package:multi_store/controller/product_controller.dart';
import 'package:multi_store/resource/theme/app_colors.dart';

import '../../../../../provider/product_provider.dart';
import '../../../../../provider/top_rated_product_provider.dart';

class TopRatedWidget extends ConsumerStatefulWidget {
  const TopRatedWidget({super.key});

  @override
  ConsumerState<TopRatedWidget> createState() => _TopRatedWidgetState();
}

class _TopRatedWidgetState extends ConsumerState<TopRatedWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final products = ref.read(productProvider);
    if (products.isEmpty) {
      _fetchProduct();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadTopRatedProducts('');
      ref.read(topRatedProductProvider.notifier).setProducts(products);
    } catch (e) {
      print("$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(topRatedProductProvider);
    return SizedBox(
      height: 250,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.bluePrimary,
            ))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItemWidget(
                  product: product,
                );
              },
            ),
    );
  }
}
