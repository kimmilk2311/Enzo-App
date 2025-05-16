import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/details/products/product_item_widget.dart';
import 'package:multi_store/provider/top_rated_product_provider.dart';

import '../../../../../controller/product_controller.dart';
import '../../../../../provider/all_product_provider.dart';
import '../../../../../provider/product_provider.dart';
import '../../../../../resource/theme/app_colors.dart';

class AllProductPage extends ConsumerStatefulWidget {
  const AllProductPage({super.key});

  @override
  ConsumerState<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends ConsumerState<AllProductPage> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
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
    try{
      final products = await productController.loadAllProducts();
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
    final products = ref.watch(allProductProvider);

    return Scaffold(
      backgroundColor: AppColors.white40,
      appBar: AppBar(
        title: const Text("Tất cả sản phẩm"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
          : products.isEmpty
          ? const Center(child: Text("Không có sản phẩm"))
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
