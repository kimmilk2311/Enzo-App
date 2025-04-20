import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/resource/theme/app_styles.dart';

import '../../../controllers/product_controller.dart';
import '../../../provider/vendor_product_provider.dart';
import '../../../resource/theme/app_colors.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({super.key});

  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final products = ref.read(vendorProductProvider);
    if (products.isEmpty) {
      _fetchProduct();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final vendor = ref.read(vendorProvider);
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadVendorProduct(vendor!.id);
      ref.read(vendorProductProvider.notifier).setProducts(products);
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
    final products = ref.watch(vendorProductProvider);
    return SizedBox(
      height: 250,
      child: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Center(
                  child: Text(
                    product.productName,
                    style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                  ),
                );
              },
            ),
    );
  }
}
