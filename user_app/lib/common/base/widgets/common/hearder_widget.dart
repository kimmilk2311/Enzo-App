import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/common/custom_search.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/ui/navigation/screens/cart_page.dart';
import 'package:multi_store/provider/cart_provider.dart';

class HeaderWidget extends ConsumerStatefulWidget {
  const HeaderWidget({super.key});

  @override
  ConsumerState<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends ConsumerState<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      child: Stack(
        children: [
          // Nen banner
          Image.asset(
            AppImages.imgSearchBanner,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          const Positioned(
            top: 60,
            left: 6,
            child: CustomSearch(),
          ),

          // Icon gio hang (ben phai)
          Positioned(
            top: 60,
            right: 40,
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return const CartPage();
                    }));
                  },
                  icon: SvgPicture.asset(
                    AppImages.icCartWhite,
                    height: 30,
                    width: 30,
                  ),
                ),
                if (cartData.isNotEmpty)
                  Positioned(
                    right: 4,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cartData.length.toString(),
                        style: AppStyles.STYLE_12_BOLD.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Icon tin nha (ben phai)
          Positioned(
            top: 60,
            right: 2,
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    AppImages.icMessWhite,
                    height: 30,
                    width: 30,
                  ),
                ),
                  Positioned(
                    right: 8,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "",
                        style: AppStyles.STYLE_12_BOLD.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
