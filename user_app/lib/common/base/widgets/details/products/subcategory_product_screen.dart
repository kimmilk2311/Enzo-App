import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/details/products/product_item_widget.dart';
import 'package:multi_store/data/model/subcategory_model.dart';
import '../../../../../provider/subcategory_product_provider.dart';

class SubcategoryProductScreen extends ConsumerWidget {
  final SubCategory subcategory;

  const SubcategoryProductScreen({super.key, required this.subcategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(subcategoryProductProvider(subcategory.subCategoryName));
    final screenWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = screenWidth < 600 ? 2 : 4;
    final childAspectRatio = screenWidth < 600 ? 2 / 4 : 4 / 5;

    return Scaffold(
      appBar: AppBar(
        title: Text(subcategory.subCategoryName),
      ),
      body: asyncProducts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Đã xảy ra lỗi: $error')),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text("Không có sản phẩm nào."));
          }

          return Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                mainAxisSpacing: 8,
                crossAxisSpacing: 9,
              ),
              itemBuilder: (context, index) {
                return ProductItemWidget(product: products[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
