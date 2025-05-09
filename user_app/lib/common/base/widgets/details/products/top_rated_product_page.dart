import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/details/products/product_item_widget.dart';
import 'package:multi_store/provider/top_rated_product_provider.dart';

import '../../../../../controller/product_controller.dart';
import '../../../../../provider/product_provider.dart';
import '../../../../../resource/theme/app_colors.dart';

class TopRatedProductPage extends ConsumerStatefulWidget {
  const TopRatedProductPage({super.key});

  @override
  ConsumerState<TopRatedProductPage> createState() => _TopRatedProductPageState();
}

class _TopRatedProductPageState extends ConsumerState<TopRatedProductPage> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final products = ref.read(productProvider);
    if (products.isEmpty) {
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try{
      final products = await productController.loadTopRatedProducts('');
      ref.read(productProvider.notifier).setProducts(products);
    }catch(e){

    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.read(topRatedProductProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Top sản phẩm",
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
          : products.isEmpty
          ? const Center(child: Text("Không có sản phẩm phổ biến"))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
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
