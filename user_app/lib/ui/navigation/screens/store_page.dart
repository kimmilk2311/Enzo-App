import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_store/controller/vendor_controller.dart';

import '../../../common/base/widgets/details/vendors/vendor_product_screen.dart';
import '../../../provider/vendor_provider.dart';
import '../../../resource/asset/app_images.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';

class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  ConsumerState<StorePage> createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  @override
  void initState() {
    super.initState();
    _fetchVendors();
  }

  Future<void> _fetchVendors() async {
    final VendorController vendorController = VendorController();
    try {
      final vendors = await vendorController.loadVendors();
      ref.read(vendorProvider.notifier).setVendors(vendors);
    } catch (e) {
      print("Error loading vendors $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(vendorProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = screenWidth < 600 ? 2 : 4;
    final childAspectRatio = screenWidth < 600 ? 2 / 4 : 4 / 5;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cửa hàng",
          style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColors.blackFont),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(AppImages.icStore, width: 28, height: 28),
              ),
              Positioned(
                right: 4,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Center(
                    child: Text(
                      vendors.length.toString(),
                      style: AppStyles.STYLE_12_BOLD.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: vendors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 8,
            crossAxisSpacing: 9,
          ),
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VendorProductScreen(vendor: vendor)));
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar của vendor
                        vendor.storeImage!.isEmpty
                            ? CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.bluePrimary,
                          child: Text(
                            vendor.fullName[0].toUpperCase(),
                            style: AppStyles.STYLE_28_BOLD.copyWith(color: AppColors.white),
                          ),
                        )
                            : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(vendor.storeImage!),
                        ),
                        const SizedBox(height: 12),
                        // Tên vendor
                        Text(
                          vendor.fullName,
                          textAlign: TextAlign.center,
                          style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.blackFont),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );


          },
        ),
      ),
    );
  }
}

