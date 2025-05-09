import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/controller/product_controller.dart';
import 'package:multi_store/data/model/product.dart';

class SubcategoryProductNotifier extends FamilyAsyncNotifier<List<Product>, String> {
  // Map để lưu trữ dữ liệu đã tải theo subCategoryName
  static final Map<String, List<Product>> _cache = {};

  @override
  Future<List<Product>> build(String subCategoryName) async {
    // Nếu đã có dữ liệu trong cache, trả về dữ liệu từ cache
    if (_cache.containsKey(subCategoryName)) {
      return _cache[subCategoryName]!;
    }

    // Tải dữ liệu từ API nếu chưa có trong cache
    final controller = ProductController();
    final products = await controller.loadProductBySubCategory(subCategoryName);

    // Lưu dữ liệu vào cache
    _cache[subCategoryName] = products;
    return products;
  }

  // Phương thức để làm mới dữ liệu
  Future<void> refresh() async {
    // Xóa dữ liệu trong cache cho subCategoryName hiện tại
    _cache.remove(arg);

    // Đặt trạng thái thành loading
    state = const AsyncValue.loading();

    try {
      // Tải lại dữ liệu
      final products = await build(arg);
      state = AsyncValue.data(products);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final subcategoryProductProvider =
AsyncNotifierProvider.family<SubcategoryProductNotifier, List<Product>, String>(
  SubcategoryProductNotifier.new,
);