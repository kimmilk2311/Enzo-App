import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/resource/theme/app_styles.dart';
import '../../../controllers/product_controller.dart';
import '../../../provider/vendor_product_provider.dart';
import '../../../resource/theme/app_colors.dart';
import '../../details/edit/edit_product_detail_screen.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi tải sản phẩm: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(vendorProductProvider);
    final vendor = ref.read(vendorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sản phẩm của ${vendor?.fullName ?? 'Vendor'}",
            style: AppStyles.STYLE_20_BOLD.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.bluePrimary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProduct,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.bluePrimary))
            : Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductDetailScreen(product: product),
                    ),
                  );
                  if (result == true) {
                    setState(() {
                      isLoading = true;
                    });
                    await _fetchProduct();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Hiển thị ảnh sản phẩm (nếu có)
                      if (product.images.isNotEmpty)
                        ClipRRect(
                          child: Image.network(
                            product.images[0],
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            // Ngăn cache hình ảnh cũ
                            cacheHeight: 100,
                            cacheWidth: 100,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                          ),
                        ),
                      const SizedBox(height: 8),
                      // Hiển thị tên sản phẩm
                      Text(
                        product.productName, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true,
                        style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.bluePrimary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}