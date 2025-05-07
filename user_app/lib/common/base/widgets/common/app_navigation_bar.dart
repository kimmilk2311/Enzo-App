import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_store/resource/asset/app_images.dart';
import 'package:multi_store/resource/theme/app_colors.dart';

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
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SvgPicture.asset(
              AppImages.icHome,
              width: 23,
              colorFilter: ColorFilter.mode(
                selectedIndex == 0 ? AppColors.blackFont : AppColors.bluePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          label: "", // Bỏ label
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SvgPicture.asset(
              AppImages.icHeart,
              width: 23,
              colorFilter: ColorFilter.mode(
                selectedIndex == 1 ? AppColors.blackFont : AppColors.bluePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SvgPicture.asset(
              AppImages.icCategory,
              width: 23,
              colorFilter: ColorFilter.mode(
                selectedIndex == 2 ? AppColors.blackFont : AppColors.bluePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SvgPicture.asset(
              AppImages.icStore,
              width: 23,
              colorFilter: ColorFilter.mode(
                selectedIndex == 3 ? AppColors.blackFont : AppColors.bluePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SvgPicture.asset(
              AppImages.icCart,
              width: 23,
              colorFilter: ColorFilter.mode(
                selectedIndex == 4 ? AppColors.blackFont : AppColors.bluePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SvgPicture.asset(
              AppImages.icUser,
              width: 23,
              colorFilter: ColorFilter.mode(
                selectedIndex == 5 ? AppColors.blackFont : AppColors.bluePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          label: "",
        ),
      ],
    );
  }
}