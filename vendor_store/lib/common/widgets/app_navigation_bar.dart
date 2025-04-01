
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resource/asset/app_images.dart';
import '../../resource/theme/app_colors.dart';


class AppNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: AppColors.bluePrimary,
      unselectedItemColor: AppColors.grey,
      currentIndex: selectedIndex,
      onTap: onTabSelected,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppImages.icHome,
            width: 25,
            colorFilter: ColorFilter.mode(
              selectedIndex == 0 ? AppColors.bluePrimary : AppColors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppImages.icHeart,
            width: 25,
            colorFilter: ColorFilter.mode(
              selectedIndex == 1 ? AppColors.bluePrimary : AppColors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppImages.icCategory,
            width: 25,
            colorFilter: ColorFilter.mode(
              selectedIndex == 2 ? AppColors.bluePrimary : AppColors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: "Categories",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppImages.icStore,
            width: 25,
            colorFilter: ColorFilter.mode(
              selectedIndex == 3 ? AppColors.bluePrimary : AppColors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: "Store",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppImages.icCart,
            width: 25,
            colorFilter: ColorFilter.mode(
              selectedIndex == 4 ? AppColors.bluePrimary : AppColors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: "Cart",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppImages.icSetting,
            width: 25,
            colorFilter: ColorFilter.mode(
              selectedIndex == 5 ? AppColors.bluePrimary : AppColors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: "Account",
        ),
      ],
    );
  }
}
