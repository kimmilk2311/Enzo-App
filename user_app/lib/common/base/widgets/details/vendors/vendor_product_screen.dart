import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:multi_store/common/base/widgets/details/products/product_item_widget.dart';
import 'package:multi_store/data/model/vendor.dart';
import 'package:multi_store/provider/vendor_product_provider.dart';

import '../../../../../controller/product_controller.dart';
import '../../../../../resource/asset/app_images.dart';
import '../../../../../resource/theme/app_colors.dart';
import '../../../../../resource/theme/app_style.dart';

class VendorProductScreen extends ConsumerStatefulWidget {
  final Vendor vendor;

  const VendorProductScreen({super.key, required this.vendor});

  @override
  ConsumerState<VendorProductScreen> createState() => _VendorProductScreenState();
}

class _VendorProductScreenState extends ConsumerState<VendorProductScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) {
     _fetchProductIfNeeded();

    });
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadVendorProducts(widget.vendor.id);
      ref.read(vendorProductProvider.notifier).setProducts(products);
    } catch (e) {
      print("$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void _fetchProductIfNeeded(){
    final products = ref.read(vendorProductProvider);
    if(products.isEmpty || products.first.vendorId != widget.vendor.id){
    ref.read(vendorProductProvider.notifier).setProducts([]);
    _fetchProduct();
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  // Định dạng tiền tệ VNĐ
  String formatCurrency(int price) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(vendorProductProvider);

    final screenWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = screenWidth < 600 ? 2 : 4;
    final childAspectRatio = screenWidth < 600 ? 2 / 4 : 4 / 5;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.vendor.fullName,
          style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColors.blackFont),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 48, // hoặc 40–50 tuỳ chỉnh
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppImages.icProduct,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        products.length.toString(),
                        textAlign: TextAlign.center,
                        style: AppStyles.STYLE_10_BOLD.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              widget.vendor.storeImage!.isEmpty
                  ? CircleAvatar(
                      radius: 40,
                      child: Text(
                        widget.vendor.fullName[0].toUpperCase(),
                        style: AppStyles.STYLE_28_BOLD.copyWith(color: AppColors.blackFont),
                      ),
                    )
                  : CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(widget.vendor.storeImage!),
                    ),
              const SizedBox(height: 10),
              widget.vendor.storeDescription!.isEmpty
                  ? const Text('')
                  : Text(
                      widget.vendor.storeDescription!,
                      style: AppStyles.STYLE_18.copyWith(color: AppColors.blackFont, letterSpacing: 1.7),
                    ),
              const SizedBox(height: 10),
              Divider(
                thickness: 1,
                color: AppColors.greyDark.withOpacity(0.5),
              ),
              const SizedBox(height: 10),
              Text("Sản phẩm của "+widget.vendor.fullName,style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColors.bluePrimary),),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : products.isEmpty?  const Text("Không có sản phẩm"): Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductItemWidget(product: product);
                    },
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
