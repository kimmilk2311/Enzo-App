import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/controller/product_controller.dart';
import 'package:multi_store/data/model/product.dart';

class SubcategoryProductNotifier extends FamilyAsyncNotifier<List<Product>, String> {
  @override
  Future<List<Product>> build(String subCategoryName) async {
    final controller = ProductController();
    return await controller.loadProductBySubCategory(subCategoryName);
  }
}

final subcategoryProductProvider =
AsyncNotifierProvider.family<SubcategoryProductNotifier, List<Product>, String>(
  SubcategoryProductNotifier.new,
);
